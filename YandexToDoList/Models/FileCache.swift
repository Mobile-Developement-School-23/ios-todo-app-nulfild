//
//  FileCache.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 17.06.2023.
//

import Foundation
import SQLite

enum FileCacheError: Error {
    case wrongNameOfFile
    case wrongData
    case dataBaseConnectionError
    case todoNotFound
}

class FileCache {
    private(set) var items: [String: TodoItem] = [:]
    private var db: Connection
    private var todos: Table
    
    init() {
//        configureDB() Метод нужно вызвать один раз, оставил, чтобы была видна реализация

        var db: Connection?
        var todos: Table?

        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            db = try Connection("\(path)/db.sqlite3")
            todos = Table("todos")
        } catch {
            print(error)
        }
        
        guard
            let db, let todos
        else { fatalError(FileCacheError.dataBaseConnectionError.localizedDescription) }

        self.db = db
        self.todos = todos
    }
    
    private func add(item: TodoItem) -> TodoItem? {
        let oldItem = items[item.id]
        items[item.id] = item
        return oldItem
    }
    
    private func remove(id: String) -> TodoItem? {
        let item = items[id]
        items[id] = nil
        return item
    }
    
    func insert(todoItem: TodoItem) throws {
        do {
            try db.run(todos.insert(FileCache.id <- todoItem.id,
                                    FileCache.text <- todoItem.text,
                                    FileCache.importance <- todoItem.importance.rawValue,
                                    FileCache.deadline <- todoItem.deadline,
                                    FileCache.isCompleted <- todoItem.isCompleted,
                                    FileCache.createDate <- todoItem.createDate,
                                    FileCache.editDate <- todoItem.editDate))
            _ = add(item: todoItem)
        } catch {
            print(error)
        }
    }
    
    func update(todoItem: TodoItem) throws {
        do {
            let todo = todos.filter(FileCache.id == todoItem.id)
            if try db.run(todo.update(FileCache.text <- todoItem.text,
                                      FileCache.importance <- todoItem.importance.rawValue,
                                      FileCache.deadline <- todoItem.deadline,
                                      FileCache.isCompleted <- todoItem.isCompleted,
                                      FileCache.createDate <- todoItem.createDate,
                                      FileCache.editDate <- todoItem.editDate)) > 0 {
                _ = add(item: todoItem)
                
            } else {
                throw FileCacheError.todoNotFound
            }
        } catch {
            print(error)
        }
    }
    
    func delete(todoItem: TodoItem) throws {
        do {
            let todo = todos.filter(FileCache.id == todoItem.id)
            if try db.run(todo.delete()) > 0 {
                _ = remove(id: todoItem.id)
            } else {
                throw FileCacheError.todoNotFound
            }
        } catch {
            print(error)
        }
    }

    func load() throws {
        do {
            for todo in try db.prepare(todos) {
                let todoItem = TodoItem.parse(id: todo[FileCache.id],
                                              text: todo[FileCache.text],
                                              importance: todo[FileCache.importance],
                                              deadline: todo[FileCache.deadline],
                                              isCompleted: todo[FileCache.isCompleted],
                                              createDate: todo[FileCache.createDate],
                                              editDate: todo[FileCache.editDate])
                if let todoItem {
                    items[todoItem.id] = todoItem
                }
            }
        } catch {
            throw FileCacheError.dataBaseConnectionError
        }
    }
}

extension FileCache {
    private static let id = Expression<String>("id")
    private static let text = Expression<String>("text")
    private static let importance = Expression<String>("importance")
    private static let deadline = Expression<Date?>("deadline")
    private static let isCompleted = Expression<Bool>("isCompleted")
    private static let createDate = Expression<Date>("createDate")
    private static let editDate = Expression<Date?>("editDate")

    private func configureDB() {
        do {
            try db.run(todos.create { t in
                t.column(FileCache.id, unique: true)
                t.column(FileCache.text)
                t.column(FileCache.importance)
                t.column(FileCache.deadline)
                t.column(FileCache.isCompleted)
                t.column(FileCache.createDate)
                t.column(FileCache.editDate)
            })
        } catch {
            print(error)
        }
    }
}

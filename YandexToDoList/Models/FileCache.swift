//
//  FileCache.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 17.06.2023.
//

import Foundation
import SQLite
import CoreData

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
            let db,
            let todos
        else { fatalError(FileCacheError.dataBaseConnectionError.localizedDescription) }

        self.db = db
        self.todos = todos
        
        configureDB()
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
    
    func save(todoItem: TodoItem) throws {
        do {
            _ = try db.scalar(todoItem.sqlReplaceStatement)
            _ = add(item: todoItem)
        } catch {
            print(error)
        }
    }
    
    func insert(todoItem: TodoItem) throws {
        do {
            let deadlineString = todoItem.deadline != nil ? String(Int(todoItem.deadline?.timeIntervalSince1970 ?? 0)) : "NULL"
            let editDateString = todoItem.editDate != nil ? String(Int(todoItem.editDate?.timeIntervalSince1970 ?? 0)) : "NULL"

            try db.run(todos.insert(
                FileCache.id <- todoItem.id,
                FileCache.text <- todoItem.text,
                FileCache.importance <- todoItem.importance.rawValue,
                FileCache.deadline <- deadlineString,
                FileCache.isCompleted <- todoItem.isCompleted,
                FileCache.createDate <- String(Int(todoItem.createDate.timeIntervalSince1970)),
                FileCache.editDate <- editDateString
            ))
            _ = add(item: todoItem)
        } catch {
            print(error)
        }
    }
    
    func update(todoItem: TodoItem) throws {
        do {
            let todo = todos.filter(FileCache.id == todoItem.id)
            
            let deadlineString = todoItem.deadline != nil ? String(Int(todoItem.deadline?.timeIntervalSince1970 ?? 0)) : "NULL"
            let editDateString = todoItem.editDate != nil ? String(Int(todoItem.editDate?.timeIntervalSince1970 ?? 0)) : "NULL"
            
            if try db.run(todo.update(
                FileCache.text <- todoItem.text,
                FileCache.importance <- todoItem.importance.rawValue,
                FileCache.deadline <- deadlineString,
                FileCache.isCompleted <- todoItem.isCompleted,
                FileCache.createDate <- String(Int(todoItem.createDate.timeIntervalSince1970)),
                FileCache.editDate <- editDateString
            )) > 0 {
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
        items = [:]
        do {
            for todo in try db.prepare(todos) {
                var deadlineDate: Date? = nil
                if todo[FileCache.deadline] != "NULL" {
                    deadlineDate = Date(timeIntervalSince1970: TimeInterval(todo[FileCache.deadline] ?? "") ?? 0)
                }
                
                var editDate: Date? = nil
                if todo[FileCache.editDate] != "NULL" {
                    editDate = Date(timeIntervalSince1970: TimeInterval(todo[FileCache.editDate] ?? "") ?? 0)
                }
                
                let todoItem = TodoItem.parse(
                    id: todo[FileCache.id],
                    text: todo[FileCache.text],
                    importance: todo[FileCache.importance],
                    deadline: deadlineDate,
                    isCompleted: todo[FileCache.isCompleted],
                    createDate: Date(timeIntervalSince1970: TimeInterval(todo[FileCache.createDate]) ?? 0),
                    editDate: editDate
                )
                if let todoItem {
                    items[todoItem.id] = todoItem
                }
            }
        } catch {
            throw FileCacheError.dataBaseConnectionError
        }
    }
}

// MARK: Настройка БД

extension FileCache {
    private static let id = Expression<String>("id")
    private static let text = Expression<String>("text")
    private static let importance = Expression<String>("importance")
    private static let deadline = Expression<String?>("deadline")
    private static let isCompleted = Expression<Bool>("isCompleted")
    private static let createDate = Expression<String>("createDate")
    private static let editDate = Expression<String?>("editDate")

    private func configureDB() {
        do {
            try db.run(todos.create(ifNotExists: true) { t in
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


// MARK: Реализация всех методов с помощью CoreData
extension FileCache {
    func loadCoreData() throws {
        items = [:]
        let mainContext = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        do {
            let results = try mainContext.fetch(fetchRequest)
            for todo in results {
                let todoItem = convertToTodoItem(todoItem: todo)
                items[todoItem.id] = todoItem
            }
        } catch {
            throw error
        }
    }
    
    func insertCoreData(todoItem: TodoItem) {
        let context = CoreDataManager.shared.backgroundContext()
        context.perform {
            let entity = TodoItemEntity.entity()
            let todo = TodoItemEntity(entity: entity, insertInto: context)
            todo.id = todoItem.id
            todo.text = todoItem.text
            todo.importance = todoItem.importance.rawValue
            todo.deadline = todoItem.deadline
            todo.isCompleted = todoItem.isCompleted
            todo.createDate = todoItem.createDate
            todo.editDate = todoItem.editDate
            
            do {
                try context.save()
                _ = self.add(item: todoItem)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func updateCoreData(todoItem: TodoItem) {
        let context = CoreDataManager.shared.backgroundContext()
        let fetchRequest: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", todoItem.id)
        do {
            let results = try context.fetch(fetchRequest)
            if results.count != 0 {
                context.delete(results[0])
                try context.save()
                insertCoreData(todoItem: todoItem)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteCoreData(todoItem: TodoItem) {
        let context = CoreDataManager.shared.backgroundContext()
        let fetchRequest: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", todoItem.id)
        do {
            let results = try context.fetch(fetchRequest)
            if results.count != 0 {
                context.delete(results[0])
                try context.save()
                _ = self.remove(id: todoItem.id)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func convertToTodoItem(todoItem: TodoItemEntity) -> TodoItem {
        guard
            let id = todoItem.id,
            let text = todoItem.text,
            let importance = todoItem.importance,
            let createDate = todoItem.createDate
        else {
            fatalError("Не получилось конвертировать модель из БД (CoreData)")
        }
        
        let todo = TodoItem.parse(
            id: id,
            text: text,
            importance: importance,
            deadline: todoItem.deadline,
            isCompleted: todoItem.isCompleted,
            createDate: createDate,
            editDate: todoItem.editDate
        )
        guard let todo else { fatalError("Не получилось конвертировать модель из БД (CoreData)") }
        return todo
    }
}

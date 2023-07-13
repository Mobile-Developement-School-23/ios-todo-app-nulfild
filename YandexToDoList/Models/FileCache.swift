//
//  FileCache.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 17.06.2023.
//

import Foundation

enum FileCacheError: Error {
    case wrongNameOfFile
    case wrongData
}

class FileCache {
    private(set) var items: [String: TodoItem] = [:]

    func add(item: TodoItem) -> TodoItem? {
        let oldItem = items[item.id]
        items[item.id] = item
        return oldItem
    }

    func remove(id: String) -> TodoItem? {
        let item = items[id]
        items[id] = nil
        return item
    }

    func saveToJson(to file: String) throws {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.wrongNameOfFile
        }

        let fullPath = dir.appending(component: "\(file).json")
        let data = items.map { _, item in item.json }
        let dataJson = try JSONSerialization.data(withJSONObject: data)
        try dataJson.write(to: fullPath)
    }

    func loadFromJson(from file: String) throws {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.wrongNameOfFile
        }

        let fullPath = dir.appending(component: "\(file).json")
        let data = try Data(contentsOf: fullPath)
        let dataJson = try JSONSerialization.jsonObject(with: data)

        guard let json = dataJson as? [Any] else {
            throw FileCacheError.wrongData
        }

        let todos = json.compactMap { TodoItem.parse(json: $0) }
        self.items = todos.reduce(into: [:]) { dict, item in
            dict[item.id] = item
        }
    }
}

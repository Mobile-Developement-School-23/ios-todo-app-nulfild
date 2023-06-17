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
    
    func add(item: TodoItem) {
        items[item.id] = item
    }
    
    func remove(id: String) {
        items[id] = nil
    }
    
    func saveToJson(to file: String) throws {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .desktopDirectory, in: .userDomainMask).first else {
            throw FileCacheError.wrongNameOfFile
        }
        
        let fullPath = dir.appending(component: "\(file).json")
        let data = items.map { _, item in item.json }
        let dataJson = try JSONSerialization.data(withJSONObject: data)
        try dataJson.write(to: fullPath)
    }
    
    func loadFromJson(from file: String) throws {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .desktopDirectory, in: .userDomainMask).first else {
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
    
    func saveToCsv(to file: String) throws {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .desktopDirectory, in: .userDomainMask).first else {
            throw FileCacheError.wrongNameOfFile
        }
        
        let fullPath = dir.appending(component: "\(file).csv")
        let csv = convertToCsv(from: self.items)
        let data = csv?.data(using: .utf8)
        try data?.write(to: fullPath)
    }
    
    func loadFromCsv(from file: String) throws {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .desktopDirectory, in: .userDomainMask).first else {
            throw FileCacheError.wrongNameOfFile
        }
        
        let fullPath = dir.appending(component: "\(file).csv")
        let data = try Data(contentsOf: fullPath)
        if let csv = String(data: data, encoding: .utf8) {
            self.items = convertFromCsv(from: csv)
        }
    }
    
    func convertToCsv(from items: [String: TodoItem]) -> String? {
        var firstString = "id,text,importance,deadline,isCompleted,createDate,editDate\n"
        var index = 0
        for todo in items.values {
            if index < items.count - 1 {
                firstString += todo.csv + "\n"
                index += 1
            } else {
                firstString += todo.csv
            }
        }
        return firstString
    }
    
    func convertFromCsv(from csv: String) -> [String: TodoItem] {
        var columns = csv.components(separatedBy: "\n")
        columns.remove(at: 0)
        let parsedData = columns.compactMap { TodoItem.parse(csv: $0) }
        return parsedData.reduce(into: [:]) { dict, item in
            dict[item.id] = item
        }
    }
}

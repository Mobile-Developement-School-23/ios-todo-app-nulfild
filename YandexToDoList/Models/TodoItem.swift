//
//  TodoItem.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 15.06.2023.
//

import Foundation

struct TodoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isCompleted: Bool
    let createDate: Date
    let editDate: Date?
    
    init(id: String = UUID().uuidString,  // TODO: Из-за условия тз пришлось поменять, было: UUID().uuidStrin
         text: String,
         importance: Importance,
         deadline: Date? = nil,
         isCompleted: Bool = false,
         createDate: Date = Date(),
         editDate: Date? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.createDate = createDate
        self.editDate = editDate
    }
}

// MARK: - JSON format

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        
        guard let todo = json as? [String: Any] else {
            return nil
        }
        
        guard
            let id = (todo["id"] as? String).flatMap({ String($0) }),
            let text = todo["text"] as? String,
            let createDate = (todo["createDate"] as? Int).flatMap({ Date(timeIntervalSince1970: TimeInterval($0)) })
        else {
            return nil
        }
        
        let importance = (todo["importance"] as? String).flatMap(Importance.init(rawValue:)) ?? .normal
        let deadline = (todo["deadline"] as? Int).flatMap { Date(timeIntervalSince1970: TimeInterval($0)) }
        let isCompleted = (todo["isCompleted"] as? Bool) ?? false
        let editDate = (todo["editDate"] as? Int).flatMap { Date(timeIntervalSince1970: TimeInterval($0)) }
        
        return TodoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        isCompleted: isCompleted,
                        createDate: createDate,
                        editDate: editDate)
    }
    
    
    
    var json: Any {
        var todo: [String: Any] = [:]
        todo["id"] = id
        todo["text"] = text
        if importance != .normal {
            todo["importance"] = importance.rawValue
        }
        if let deadline = deadline {
            todo["deadline"] = Int(deadline.timeIntervalSince1970)
        }
        todo["isCompleted"] = isCompleted
        todo["createDate"] = Int(createDate.timeIntervalSince1970)
        if let editDate = editDate {
            todo["editDate"] = Int(editDate.timeIntervalSince1970)
        }
        return todo
    }
}

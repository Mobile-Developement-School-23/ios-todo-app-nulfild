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
    
    init(
        id: String = UUID().uuidString,  // TODO: Из-за условия тз пришлось поменять, было: UUID().uuidStrin
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isCompleted: Bool = false,
        createDate: Date = Date(),
        editDate: Date? = nil
    ) {
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
    static func parse(
        id: String,
        text: String,
        importance: String,
        deadline: Date?,
        isCompleted: Bool,
        createDate: Date,
        editDate: Date?
    ) -> TodoItem? {
                
        return TodoItem(
            id: id,
            text: text,
            importance: Importance(rawValue: importance) ?? .normal,
            deadline: deadline,
            isCompleted: isCompleted,
            createDate: createDate,
            editDate: editDate
        )
    }
    
    var sqlReplaceStatement: String {
        let isCompletedString = isCompleted ? "1" : "0"
        let deadlineString = deadline != nil ? String(deadline?.timeIntervalSince1970 ?? 0) : "NULL"
        let createDateString = String(createDate.timeIntervalSince1970)
        let editDateString = editDate != nil ? String(editDate?.timeIntervalSince1970 ?? 0) : "NULL"
        return """
        REPLACE INTO todos (id, text, importance, deadline, isCompleted, createDate, editDate)
        VALUES ('\(id)', '\(text)', '\(importance.rawValue)', '\(deadlineString)', \(isCompletedString), '\(createDateString)', '\(editDateString)');
        """
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

//
//  YandexToDoListTests.swift
//  YandexToDoListTests
//
//  Created by Герман Кунин on 15.06.2023.
//

import XCTest
@testable import YandexToDoList

final class YandexToDoListTests: XCTestCase {
    
    private let id = "1"
    private let text = "Something"
    private let isCompleted = false
    private let createDate = Date()
    
    private var importance = Importance.important
    private var deadline: Date? = Date()
    private var editDate: Date? = Date()
    private var deadlineIntValue: Int {
        Int(self.deadline?.timeIntervalSince1970 ?? 0)
    }
    private var createDateIntValue: Int {
        Int(self.createDate.timeIntervalSince1970)
    }
    private var editDateIntValue: Int {
        Int(self.editDate?.timeIntervalSince1970 ?? 0)
    }
    
    
    private var item: TodoItem!
    
    override func setUpWithError() throws {
        super.setUp()
        item = TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isCompleted: isCompleted,
            createDate: createDate,
            editDate: editDate)
    }
    
    func testCreateTodoItemWithValidValues() {
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.importance, importance)
        XCTAssertEqual(item.deadline, deadline)
        XCTAssertEqual(item.isCompleted, isCompleted)
        XCTAssertEqual(item.createDate, createDate)
        XCTAssertEqual(item.editDate, editDate)
    }
    
    func testCreateTodoItemWithoutMandatoryValues() {
        let item = TodoItem(
            id: "",
            text: "",
            importance: importance,
            deadline: deadline,
            isCompleted: isCompleted,
            createDate: createDate,
            editDate: editDate
        )
        
        XCTAssertFalse(item.id == id)
        XCTAssertFalse(item.text == text)
        XCTAssertEqual(item.importance, importance)
        XCTAssertEqual(item.deadline, deadline)
        XCTAssertEqual(item.isCompleted, isCompleted)
        XCTAssertEqual(item.createDate, createDate)
        XCTAssertEqual(item.editDate, editDate)
    }
    
    func testCreateTodoItemWithNilDates() {
        let item = TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: nil,
            isCompleted: isCompleted,
            createDate: createDate,
            editDate: nil
        )
        
        XCTAssertNil(item.deadline)
        XCTAssertNil(item.editDate)
    }
    
    func testTodoItemToJson() {
        guard let result = item.json as? [String: Any] else {
            XCTFail("Fail")
            return
        }
        
        XCTAssertEqual(result["id"] as? String, id)
        XCTAssertEqual(result["text"] as? String, text)
        XCTAssertEqual(result["importance"] as? String, importance.rawValue)
        XCTAssertEqual(result["isCompleted"] as? Bool, isCompleted)
        XCTAssertEqual(result["deadline"] as? Int, Int(deadline?.timeIntervalSince1970 ?? 0))
        XCTAssertEqual(result["createDate"] as? Int, Int(createDate.timeIntervalSince1970))
        XCTAssertEqual(result["editDate"] as? Int, Int(editDate?.timeIntervalSince1970 ?? 0))
    }
    
    func testTodoItemToJsonWithDates() {
        guard let result = item.json as? [String: Any] else {
            XCTFail("Fail")
            return
        }
        
        XCTAssertNotNil(result["deadline"])
        XCTAssertNotNil(result["editDate"])
        XCTAssertEqual(result["deadline"] as? Int, Int(deadline?.timeIntervalSince1970 ?? 0))
        XCTAssertEqual(result["editDate"] as? Int, Int(editDate?.timeIntervalSince1970 ?? 0))
    }
    
    func testTodoItemToJsonWithNilDates() {
        deadline = nil
        editDate = nil
        
        let item = TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isCompleted: isCompleted,
            createDate: createDate,
            editDate: editDate
        )
        
        guard let result = item.json as? [String: Any] else {
            XCTFail("Fail")
            return
        }
        
        XCTAssertEqual(result["deadline"] as? Int, nil)
        XCTAssertEqual(result["editDate"] as? Int, nil)
    }
    
    func testTodoItemToJsonWithImportanceNormal() {
        importance = Importance.normal
        
        let item = TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: Date(),
            isCompleted: isCompleted,
            createDate: createDate,
            editDate: editDate
        )
        
        guard let result = item.json as? [String: Any] else {
            XCTFail("Fail")
            return
        }
        
        
        XCTAssertNil(result["importance"])
    }
    
    func testParseTodoItemFromJson() {
        let json: [String: Any] = [
            "id": id,
            "text": text,
            "importance": importance.rawValue,
            "deadline": deadlineIntValue,
            "isCompleted": isCompleted,
            "createDate": createDateIntValue,
            "editDate": editDateIntValue
        ]
        
        guard let item = TodoItem.parse(json: json) else {
            XCTFail("Fail")
            return
        }
        
        XCTAssertEqual(item.id, id)
        XCTAssertEqual(item.text, text)
        XCTAssertEqual(item.importance, importance)
        XCTAssertEqual(item.isCompleted, isCompleted)
        XCTAssertEqual(Int(item.deadline?.timeIntervalSince1970 ?? 0), deadlineIntValue)
        XCTAssertEqual(Int(item.createDate.timeIntervalSince1970), createDateIntValue)
        XCTAssertEqual(Int(item.editDate?.timeIntervalSince1970 ?? 0), editDateIntValue)
    }
    
    func testTodoItemToCsvWithTextWithСommas() {
        let item = TodoItem(
            id: id,
            text: "Something, coma",
            importance: importance,
            deadline: deadline,
            isCompleted: isCompleted,
            createDate: createDate,
            editDate: editDate
        )
        
        let csvString = item.csv
        
        XCTAssertTrue(csvString.contains("~"))
    }
    
    func testParseTodoItemFromCsvWithImportanceNotNormal() {
        let deadline = "1686614400"
        let createDate = "1686614400"
        let editDate = "1686614400"
        
        let someString = "\(id),\(text),\(importance.rawValue),\(deadline),\(isCompleted),\(createDate),\(editDate)"
        
        guard let item = TodoItem.parse(csv: someString) else {
            return
        }
        
        XCTAssertEqual(item.importance.rawValue, importance.rawValue)
    }
    
    func testParseTodoItemFromCsv() {
        let deadline = "1686614400"
        let createDate = "1686614400"
        let editDate = "1686614400"
        
        let sampleString = "\(id),\(text),\(importance.rawValue),\(deadline),\(isCompleted),\(createDate),\(editDate)"
        
        guard let item = TodoItem.parse(csv: sampleString) else {
            return
        }
        
        let parts = sampleString.components(separatedBy: ",")
        
        XCTAssertEqual(item.id, parts[0])
        XCTAssertEqual(item.text, parts[1])
        XCTAssertEqual(item.importance, Importance(rawValue: parts[2]))
        XCTAssertEqual(item.deadline, Date(timeIntervalSince1970: TimeInterval(parts[3]) ?? 0))
        XCTAssertEqual(item.isCompleted, Bool(parts[4]))
        XCTAssertEqual(item.createDate, Date(timeIntervalSince1970: TimeInterval(parts[5]) ?? 0))
        XCTAssertEqual(item.editDate, Date(timeIntervalSince1970: TimeInterval(parts[6]) ?? 0))
    }
}

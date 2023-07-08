//
//  DefaultNetworkingService.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 08.07.2023.
//

import Foundation

private enum DefaultNetworkingServiceError: Error {
    case wrongURL
    case badStatusCode
    case unexpectedResponse
    case parsingFail
    case noItemWithId
}

class DefaultNetworkingService: NetworkingService {
    
    private static let token = "outboards"
    private let urlSession: URLSession
    private let deviceID: String
    private var revision: Int32 = 0
    private let goodStatusCodes = 200..<300
    var isDirty: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isDirty")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isDirty")
        }
    }
    
    init(deviceID: String, urlSession: URLSession = .shared) {
        self.deviceID = deviceID
        self.urlSession = urlSession
    }
    
    func getList() async throws -> [TodoItem] {
        let url = try makeUrl(path: "list")
        let request = makeRequest(for: url, method: "GET")
        
        let (data, response) = try await urlSession.dataTask(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceError.unexpectedResponse
        }
        guard goodStatusCodes.contains(response.statusCode) else {
            throw DefaultNetworkingServiceError.badStatusCode
        }
        guard let jsonRaw = try? JSONSerialization.jsonObject(with: data, options: []),
              let json = jsonRaw as? [String: Any],
              let todos = json["list"] as? [[String: Any]],
              let newRevision = json["revision"] as? Int32 else {
            throw DefaultNetworkingServiceError.parsingFail
        }
        
        self.revision = newRevision
        var todoItems: [TodoItem] = []
        for todo in todos {
            if let todo = TodoItem.parse(json: todo) {
                todoItems.append(todo)
            }
        }
        
        return todoItems
    }
    
    func patchList(todoItems: [TodoItem]) async throws -> [TodoItem] {
        let url = try makeUrl(path: "list/")
        var request = makeRequest(for: url, method: "PATCH")
        request.setValue("\(self.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        let todoItemsJson = todoItems.map { $0.parseToJson(deviceId: deviceID) } as! [[String: Any]]
        
        let json: [String: Any] = [
            "status": "ok",
            "list": todoItemsJson
        ]
        
        guard let body = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
            throw DefaultNetworkingServiceError.parsingFail
        }
        request.httpBody = body
        
        let (data, response) = try await urlSession.dataTask(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceError.unexpectedResponse
        }
        guard goodStatusCodes.contains(response.statusCode) else {
            throw DefaultNetworkingServiceError.badStatusCode
        }
        guard let jsonRaw = try? JSONSerialization.jsonObject(with: data, options: []),
              let json = jsonRaw as? [String: Any],
              let todos = json["list"] as? [[String: Any]],
              let newRevision = json["revision"] as? Int32 else {
            throw DefaultNetworkingServiceError.parsingFail
        }
        
        self.revision = newRevision
        
        var todoItems: [TodoItem] = []
        for todo in todos {
            if let todo = TodoItem.parse(json: todo) {
                todoItems.append(todo)
            }
        }
        return todoItems
    }
    
    func getItemById(id: String) async throws -> TodoItem? {
        let url = try makeUrl(path: "list/\(id)")
        var request = makeRequest(for: url, method: "GET")
        request.setValue("\(self.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        let (data, response) = try await urlSession.dataTask(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceError.unexpectedResponse
        }
        if response.statusCode == 404 {
            return nil
        }
        guard goodStatusCodes.contains(response.statusCode) else {
            print("Code: \(response.statusCode)")
            throw DefaultNetworkingServiceError.badStatusCode
        }
        guard let jsonRaw = try? JSONSerialization.jsonObject(with: data, options: []),
              let json = jsonRaw as? [String: Any],
              let todo = json["element"] as? [String: Any],
              let newRevision = json["revision"] as? Int32 else {
            throw DefaultNetworkingServiceError.parsingFail
        }
        
        self.revision = newRevision
        
        if let newTodoItem = TodoItem.parse(json: todo) {
            return newTodoItem
        }
        
        return nil
    }
    
    func addItem(todoItem: TodoItem) async throws -> TodoItem? {
        let url = try makeUrl(path: "list")
        var request = makeRequest(for: url, method: "POST")
        request.setValue("\(self.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        let json: [String: Any] = [
            "status": "ok",
            "element": todoItem.parseToJson(deviceId: deviceID)
        ]
        
        guard let body = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
            fatalError("Error!")
        }
        
        request.httpBody = body
        
        let (data, response) = try await urlSession.dataTask(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceError.unexpectedResponse
        }
        guard goodStatusCodes.contains(response.statusCode) else {
            throw DefaultNetworkingServiceError.badStatusCode
        }
        guard let jsonRaw = try? JSONSerialization.jsonObject(with: data, options: []),
              let json = jsonRaw as? [String: Any],
              let todo = json["element"] as? [String: Any],
              let newRevision = json["revision"] as? Int32 else {
            throw DefaultNetworkingServiceError.parsingFail
        }
        
        self.revision = newRevision
        
        
        if let newTodoItem = TodoItem.parse(json: todo) {
            return newTodoItem
        }
        
        return nil
        
    }
    
    func putItem(todoItem: TodoItem) async throws -> TodoItem? {
        let url = try makeUrl(path: "list/\(todoItem.id)")
        var request = makeRequest(for: url, method: "PUT")
        request.setValue("\(self.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        let json: [String: Any] = [
            "status": "ok",
            "element": todoItem.parseToJson(deviceId: self.deviceID)
        ]
        
        guard let body = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
            throw DefaultNetworkingServiceError.parsingFail
        }
        
        request.httpBody = body
        
        let (data, response) = try await urlSession.dataTask(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceError.unexpectedResponse
        }
        if response.statusCode == 404 {
            return try await self.addItem(todoItem: todoItem)
        }
        guard goodStatusCodes.contains(response.statusCode) else {
            throw DefaultNetworkingServiceError.badStatusCode
        }
        guard let jsonRaw = try? JSONSerialization.jsonObject(with: data, options: []),
              let json = jsonRaw as? [String: Any],
              let todo = json["element"] as? [String: Any],
              let newRevision = json["revision"] as? Int32 else {
            throw DefaultNetworkingServiceError.parsingFail
        }
        
        self.revision = newRevision
        
        if let newTodoItem = TodoItem.parse(json: todo) {
            return newTodoItem
        }
        
        return nil
    }
    
    
    func deleteItemById(id: String) async throws -> TodoItem? {
        let url = try makeUrl(path: "list/\(id)")
        var request = makeRequest(for: url, method: "DELETE")
        request.setValue("\(self.revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        let (data, response) = try await urlSession.dataTask(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw DefaultNetworkingServiceError.unexpectedResponse
        }
        guard response.statusCode != 404 else {
            print("\nThere is no task with id:\(id)\n")
            throw DefaultNetworkingServiceError.noItemWithId
        }
        guard goodStatusCodes.contains(response.statusCode) else {
            throw DefaultNetworkingServiceError.badStatusCode
        }
        guard let jsonRaw = try? JSONSerialization.jsonObject(with: data, options: []),
              let json = jsonRaw as? [String: Any],
              let todo = json["element"] as? [String: Any],
              let newRevision = json["revision"] as? Int32 else {
            throw DefaultNetworkingServiceError.parsingFail
        }
        
        self.revision = newRevision
        
        
        if let newTodoItem = TodoItem.parse(json: todo) {
            return newTodoItem
        }
        return nil
    }
    
    private func makeUrl(path: String) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "beta.mrdekk.ru"
        components.path = "/todobackend/\(path)"
        guard let url = components.url else {
            throw DefaultNetworkingServiceError.wrongURL
        }
        return url
    }
    
    private func makeRequest(for url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.setValue("Bearer outboards", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 60
        request.cachePolicy = .useProtocolCachePolicy
        return request
    }
}

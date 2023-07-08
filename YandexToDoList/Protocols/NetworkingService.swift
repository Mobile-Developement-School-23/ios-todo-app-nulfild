//
//  NetworkingService.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 08.07.2023.
//

import Foundation

protocol NetworkingService: AnyObject {
    func getList() async throws -> [TodoItem]
    func patchList(todoItems: [TodoItem]) async throws -> [TodoItem]
    func getItemById(id: String) async throws -> TodoItem?
    func addItem(todoItem: TodoItem) async throws -> TodoItem?
    func putItem(todoItem: TodoItem) async throws -> TodoItem?
    func deleteItemById(id: String) async throws -> TodoItem?
}

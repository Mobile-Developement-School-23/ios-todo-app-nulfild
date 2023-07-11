//
//  NetworkingService.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 08.07.2023.
//

import Foundation

protocol NetworkingService: AnyObject {
    @MainActor
    func getList() async throws -> [TodoItem]
    @MainActor
    func patchList(todoItems: [TodoItem]) async throws -> [TodoItem]
    @MainActor
    func getItemById(id: String) async throws -> TodoItem?
    @MainActor
    func addItem(todoItem: TodoItem) async throws -> TodoItem?
    @MainActor
    func putItem(todoItem: TodoItem) async throws -> TodoItem?
    @MainActor
    func deleteItemById(id: String) async throws -> TodoItem?
}

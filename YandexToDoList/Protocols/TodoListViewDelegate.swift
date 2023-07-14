//
//  TodoListViewDelegate.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 28.06.2023.
//

import UIKit

protocol TodoListViewDelegate: AnyObject {
    @MainActor
    func creatureButtonDidTapped()
    @MainActor
    func didSelectRowAt(_ todoItem: TodoItem?)
    @MainActor
    func saveTodo(_ todoItem: TodoItem)
    @MainActor
    func deleteTodo(_ todoItem: TodoItem)
    @MainActor
    func settingsButtonDidTapped()
}

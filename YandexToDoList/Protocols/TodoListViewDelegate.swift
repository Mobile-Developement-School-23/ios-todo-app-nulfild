//
//  TodoListViewDelegate.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 28.06.2023.
//

import UIKit

protocol TodoListViewDelegate: AnyObject {
    func creatureButtonDidTapped()
    func didSelectRowAt(_ todoItem: TodoItem?)
    func saveTodo(_ todoItem: TodoItem)
    func deleteTodo(_ todoItem: TodoItem)
}

//
//  CustomTableViewCellDelegate.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 01.07.2023.
//

import Foundation

protocol CustomTableViewCellDelegate: AnyObject {
    @MainActor
    func saveTodo(_ todo: TodoItem)
}

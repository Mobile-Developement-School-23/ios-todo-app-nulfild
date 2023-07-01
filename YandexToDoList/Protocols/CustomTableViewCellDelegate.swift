//
//  CustomTableViewCellDelegate.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 01.07.2023.
//

import Foundation

protocol CustomTableViewCellDelegate: AnyObject {
    func saveTodo(_ todo: TodoItem)
}

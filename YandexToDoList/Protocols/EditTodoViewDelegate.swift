//
//  EditTodoViewDelegate.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 28.06.2023.
//

import UIKit

protocol EditTodoViewDelegate: AnyObject {
    func textDidBeginEditing(textView: UITextView)
    @MainActor
    func textDidEndEditing(textView: UITextView)
    @MainActor
    func textDidChange(_ textView: UITextView)
    @MainActor
    func deleteButtonDidTapped(_ todoItem: TodoItem)
}

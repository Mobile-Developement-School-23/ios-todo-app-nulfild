//
//  EditTodoViewDelegate.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 28.06.2023.
//

import UIKit

protocol EditTodoViewDelegate: AnyObject {
    func textDidBeginEditing(textView: UITextView)
    func textDidEndEditing(textView: UITextView)
    func textDidChange(_ textView: UITextView)
    func deleteButtonDidTapped()
}

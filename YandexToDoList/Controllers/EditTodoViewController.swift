//
//  EditTodoViewController.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 24.06.2023.
//

import UIKit

class EditTodoViewController: UIViewController {
    
    private let todoItem: TodoItem?
    private var editTodoView: EditTodoView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavBar()
    }
    
    init(todoItem: TodoItem?) {
        self.todoItem = todoItem
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit of EditTodoViewController")
    }
    
    @objc private func cancelButtonDidTapped() {
        dismiss(animated: true)
    }
    @objc private func saveButtonDidTapped() {
//        let fc = FileCache()
//        var importance: Importance = .normal
//        switch importanceView.segmentControl.selectedSegmentIndex {
//        case 0: importance = .low
//        case 1: importance = .normal
//        default: importance = .important
//        }
//        let todo = TodoItem(
//            text: textView.text,
//            importance: importance,
//            deadline: importanceView.deadlineSwitch.isOn ? importanceView.datePicker.date : nil
//        )
//        fc.add(item: todo)
//        try? fc.saveToJson(to: "TodoItems")
        dismiss(animated: true)
    }
}

// MARK: EditTodoViewDelegate

extension EditTodoViewController: EditTodoViewDelegate {
    
    // Предотвращение сохранения todo с пробелами
    func textDidChange(_ textView: UITextView) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedText.isEmpty {
            if let rightButton = navigationItem.rightBarButtonItem {
                rightButton.isEnabled = true
                rightButton.tintColor = .blue
            }
        } else {
            if let rightButton = navigationItem.rightBarButtonItem {
                rightButton.isEnabled = false
                rightButton.tintColor = .labelTertiary
            }
        }
    }
    
    // Удаление placeholder'a
    func textDidBeginEditing(textView: UITextView) {
        if textView.textColor?.cgColor == UIColor.labelTertiary.cgColor {
            textView.text = nil
            textView.textColor = .labelPrimary
        }
    }
    
    // Добавление placeholder'a
    func textDidEndEditing(textView: UITextView) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = .labelTertiary
        }
        if trimmedText.isEmpty {
            if let rightButton = navigationItem.rightBarButtonItem {
                rightButton.isEnabled = false
                rightButton.tintColor = .labelTertiary
            }
        }
    }
    
    func deleteButtonDidTapped() {
        // TODO: Перенести это все в главный контроллер, чтобы не плодить экземпляры FileCache
        let fc = FileCache()
        try? fc.loadFromJson(from: "TodoItems")
        fc.remove(id: "1")
        try? fc.saveToJson(to: "TodoItems")
        dismiss(animated: true)
    }
    
}

// MARK: Configuration of View

extension EditTodoViewController {
    private func setupView() {
        editTodoView = EditTodoView(todoItem: todoItem)
        editTodoView?.delegate = self
        view = self.editTodoView
    }
    
    private func setupNavBar() {
        title = "Дело"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.headline]
        view.backgroundColor = .backPrimary
        
        let cancelButton = UIBarButtonItem(
            title: "Отменить",
            style: .plain,
            target: self,
            action: #selector(cancelButtonDidTapped)
        )
        
        let saveButton = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(saveButtonDidTapped)
        )
        
        cancelButton.tintColor = .blue
        saveButton.isEnabled = false
        saveButton.tintColor = .labelTertiary
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
}

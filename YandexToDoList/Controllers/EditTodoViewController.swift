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
    weak var delegate: TodoListViewController?

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

    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateData()
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        view.setNeedsUpdateConstraints()
    }

    @objc private func cancelButtonDidTapped() {
        dismiss(animated: true)
    }

    @objc private func saveButtonDidTapped() {
        var importance: Importance = .normal
        switch editTodoView?.optionsTodoView.segmentControl.selectedSegmentIndex {
        case 0: importance = .low
        case 1: importance = .normal
        default: importance = .important
        }
        let todo = TodoItem(
            id: todoItem?.id ?? UUID().uuidString,
            text: editTodoView?.textView.text ?? "Error",
            importance: importance,
            deadline: (editTodoView?.optionsTodoView.deadlineSwitch.isOn ?? false) ? editTodoView?.optionsTodoView.datePicker.date : nil
        )
        delegate?.saveTodo(todo)
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

    func deleteButtonDidTapped(_ todoItem: TodoItem) {
        // TODO: Перенести это все в главный контроллер, чтобы не плодить экземпляры FileCache
        delegate?.deleteTodo(todoItem)
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
        
        if todoItem != nil {
            saveButton.isEnabled = true
            saveButton.tintColor = .blue
        } else {
            saveButton.isEnabled = false
            saveButton.tintColor = .labelTertiary
        }

        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
}

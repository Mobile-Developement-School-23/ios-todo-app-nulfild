//
//  TodoListViewController.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 15.06.2023.
//

import UIKit
import FileCachePackage

class TodoListViewController: UIViewController {
    var todoListView: TodoListView?
    let fc = FileCache<TodoItem>()
    private var todoItems: [TodoItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavBar()
        updateData()
        
        // Test dataTask
        test()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateData()
    }

    func updateData() {
        try? fc.loadFromJson(from: "TodoItems")
        todoItems = Array(fc.todoItemsList.values)
        todoItems.sort(by: {$0.createDate > $1.createDate})
        todoListView?.updateData(todoItems: todoItems)
    }
}

// MARK: TodoListViewDelegate

extension TodoListViewController: TodoListViewDelegate {
    func didSelectRowAt(_ todoItem: TodoItem?) {
        let editTodoViewController = EditTodoViewController(todoItem: todoItem)
        editTodoViewController.delegate = self
        let navController = UINavigationController(rootViewController: editTodoViewController)
        present(navController, animated: true)
    }

    func creatureButtonDidTapped() {
        let editTodoViewController = EditTodoViewController(todoItem: nil)
        editTodoViewController.delegate = self
        let navController = UINavigationController(rootViewController: editTodoViewController)
        present(navController, animated: true)
    }
    func saveTodo(_ todoItem: TodoItem) {
        _ = fc.addItem(todoItem)
        try? fc.saveToJson(to: "TodoItems")
        updateData()
    }
    func deleteTodo(_ todoItem: TodoItem) {
        _ = fc.deleteItem(with: todoItem.id)
        try? fc.saveToJson(to: "TodoItems")
        updateData()
    }
}

// MARK: Configuration of View

extension TodoListViewController {
    private func setupView() {
        todoListView = TodoListView(todoItems: todoItems)
        todoListView?.delegate = self
        view = todoListView
    }

    private func setupNavBar() {
        title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
    }
}

//
//  TodoListViewController.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 15.06.2023.
//

import UIKit

class TodoListViewController: UIViewController {
    private var todoListView: TodoListView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavBar()
        let fc = FileCache()
        try? fc.loadFromJson(from: "TodoItems")
//        creat ionViewController.todoItem = fc.items.first?.value
    }
}

// MARK: TodoListViewDelegate

extension TodoListViewController: TodoListViewDelegate {
    func creatureButtonDidTapped() {
        let editTodoViewController = EditTodoViewController(todoItem: nil)
        let navController = UINavigationController(rootViewController: editTodoViewController)
        present(navController, animated: true)
    }
}

// MARK: Configuration of View

extension TodoListViewController {
    private func setupView() {
        todoListView = TodoListView()
        todoListView?.delegate = self
        view = todoListView
    }
    
    private func setupNavBar() {
        title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}



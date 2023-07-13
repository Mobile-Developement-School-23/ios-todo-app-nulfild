//
//  TodoListViewController.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 15.06.2023.
//

import UIKit

class TodoListViewController: UIViewController {
    var todoListView: TodoListView?
    let fc = FileCache()
    var todoItems: [TodoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavBar()
        updateData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateData()
    }
    
    func updateData() {
        do {
            try fc.load()
        } catch {
            print(error)
        }

        todoItems = Array(fc.items.values)
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
        do {
            if fc.items["\(todoItem.id)"] == nil {
                try fc.insert(todoItem: todoItem)
            } else {
                try fc.update(todoItem: todoItem)
            }
        } catch {
            print(error)
        }
        
        updateData()
    }
    
    func deleteTodo(_ todoItem: TodoItem) {
        do {
            try fc.delete(todoItem: todoItem)
        } catch {
            print(error)
        }

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

//
//  TodoListViewController.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 15.06.2023.
//

import UIKit

class TodoListViewController: UIViewController {
    var todoListView: TodoListView?
    var todoItems: [TodoItem] = []
    let networkingService = DefaultNetworkingService(deviceID: UIDevice.current.identifierForVendor?.uuidString ?? "Unknown")
    
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
            Task(priority: .userInitiated) { [weak self] in
                guard let self = self else { return }
                do {
                    let todoList = try await networkingService.getList()
                    todoItems.removeAll()
                    for item in todoList {
                        todoItems.append(item)
                    }
                    todoItems.sort(by: {$0.createDate > $1.createDate})
                    todoListView?.updateData(todoItems: todoItems)
                } catch {
                    print("Error")
                }
            }
            networkingService.isDirty = false
        
        
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
        if todoItems.contains(where: {$0.id == todoItem.id}) {
            Task {
                let _ = try await networkingService.putItem(todoItem: todoItem)
                updateData()
            }
        } else {
            Task {
                let _ = try await networkingService.addItem(todoItem: todoItem)
                updateData()
            }
        }
        
        if networkingService.isDirty {
            updateData()
            networkingService.isDirty = false
        }
    }
    
    func deleteTodo(_ todoItem: TodoItem) {
        Task {
            let _ = try await networkingService.deleteItemById(id: todoItem.id)
            updateData()
        }
        
        if networkingService.isDirty {
            updateData()
            networkingService.isDirty = false
        }
        
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

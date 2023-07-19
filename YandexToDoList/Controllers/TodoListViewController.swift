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
    var searchText = ""
    var isSQLInUse: Bool = UserDefaults.standard.bool(forKey: "isSQLInUse") {
        willSet {
            UserDefaults.standard.setValue("\(newValue)", forKey: "isSQLInUse")
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        loadData()
        configureGestureRecognizer()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateData()
    }
    
    func updateData() {
        todoItems = Array(fc.items.values)
        todoItems.sort(by: { $0.createDate > $1.createDate })
        if searchText != "" {
            todoItems = todoItems.filter({ $0.text.lowercased().contains(searchText.lowercased()) })
        }
        todoListView?.updateData(todoItems: todoItems)
    }
    
    func loadData() {
        do {
            isSQLInUse ? try fc.load() : try fc.loadCoreData()
        } catch {
            print(error)
        }
        updateData()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
                isSQLInUse ? try fc.insert(todoItem: todoItem) : fc.insertCoreData(todoItem: todoItem)
            } else {
                isSQLInUse ? try fc.update(todoItem: todoItem) : fc.updateCoreData(todoItem: todoItem)
            }
        } catch {
            print(error)
        }
        
        updateData()
    }
    
    func deleteTodo(_ todoItem: TodoItem) {
        do {
            isSQLInUse ? try fc.delete(todoItem: todoItem) : fc.deleteCoreData(todoItem: todoItem)
        } catch {
            print(error)
        }

        updateData()
    }

    func settingsButtonDidTapped() {
        let changeModeViewController = ChangeModeViewController()
        changeModeViewController.delegate = self
        present(changeModeViewController, animated: true)
    }
    
    func searchBarTextDidChanged(text: String) {
        searchText = text
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
        navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 22)
    }
    
    private func configureGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

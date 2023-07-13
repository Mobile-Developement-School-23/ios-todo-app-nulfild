//
//  TodoListView.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 28.06.2023.
//

import UIKit

class TodoListView: UIView {
    weak var delegate: TodoListViewDelegate?
    var todoItems: [TodoItem]
    var notCompletedTodoItems: [TodoItem]
    var isCompletedShowing: Bool = false

    let headerTableView = HeaderTableView(frame: CGRect(x: 0, y: 0, width: 0, height: 42))

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.register(NewTodoTableViewCell.self, forCellReuseIdentifier: NewTodoTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 52, bottom: 0.0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 112, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var creatureButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(nil, action: #selector(creatureButtonDidTapped), for: .touchUpInside)
        button.layer.cornerRadius = 0.5 * 44
        button.setImage(UIImage(named: "creatureButton"), for: .normal)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: init()

    init(todoItems: [TodoItem]) {
        self.todoItems = todoItems
        self.notCompletedTodoItems = todoItems.filter({!$0.isCompleted})
        super.init(frame: .zero)

        self.headerTableView.delegate = self
        setupView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func creatureButtonDidTapped() {
        delegate?.creatureButtonDidTapped()
    }

    func updateCompletition(todoItem: TodoItem) {
        delegate?.saveTodo(TodoItem(id: todoItem.id,
                                    text: todoItem.text,
                                    importance: todoItem.importance,
                                    deadline: todoItem.deadline,
                                    isCompleted: !todoItem.isCompleted,
                                    createDate: todoItem.createDate,
                                    editDate: todoItem.editDate))
    }

    func deleteTodo(todoItem: TodoItem) {
        delegate?.deleteTodo(todoItem)
    }

    func openEditTodo(indexPath: IndexPath) {
        if (indexPath.row == todoItems.count && isCompletedShowing) || (indexPath.row == notCompletedTodoItems.count && !isCompletedShowing) {
            delegate?.creatureButtonDidTapped()
        } else {
            if isCompletedShowing {
                delegate?.didSelectRowAt(todoItems[indexPath.row])
            } else {
                delegate?.didSelectRowAt(notCompletedTodoItems[indexPath.row])
            }
        }
    }

    func getCurrentTodoItem(indexPath: IndexPath) -> TodoItem {
        if isCompletedShowing {
            return todoItems[indexPath.row]
        } else {
            return notCompletedTodoItems[indexPath.row]
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension TodoListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCompletedShowing {
            return todoItems.count + 1
        } else {
            return notCompletedTodoItems.count + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == todoItems.count && isCompletedShowing) || (indexPath.row == notCompletedTodoItems.count && !isCompletedShowing) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewTodoTableViewCell.identifier, for: indexPath) as? NewTodoTableViewCell else {
                fatalError("Could not load custom table view cell")
            }
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
                fatalError("Could not load custom table view cell")
            }
            cell.backgroundColor = .backSecondary
            cell.selectionStyle = .none
            cell.delegate = self
            if isCompletedShowing {
                cell.configure(with: todoItems[indexPath.row])
            } else {
                cell.configure(with: notCompletedTodoItems[indexPath.row])
            }
            return cell
        }
    }

    // Скругялем крайние ячейки

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius: CGFloat = 16
        if tableView.isFirstRow(indexPath) && tableView.isLastRow(indexPath) {
            cell.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: cornerRadius)
        } else if tableView.isFirstRow(indexPath) {
            // Круглые углы для верхней ячейки
            cell.roundCorners(corners: [.topLeft, .topRight], radius: cornerRadius)
        } else if tableView.isLastRow(indexPath) {
            // Круглые углы для нижней ячейки
            cell.roundCorners(corners: [.bottomLeft, .bottomRight], radius: cornerRadius)
        } else {
            // Сброс углов для остальных ячеек
            cell.roundCorners(corners: [], radius: 0.0)
        }
    }

    // Реализация свайпа ячеек

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (indexPath.row == todoItems.count && isCompletedShowing) || (indexPath.row == notCompletedTodoItems.count && !isCompletedShowing) {
            return nil
        }

        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completion) in
            guard let self = self else { return }
            var todoItem: TodoItem
            if self.isCompletedShowing {
                todoItem = self.todoItems[indexPath.row]
            } else {
                todoItem = self.notCompletedTodoItems[indexPath.row]
            }
            self.updateCompletition(todoItem: todoItem)
            completion(true)
        }

        action.image = UIImage(named: "doneAction")
        action.backgroundColor = .green

        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if (indexPath.row == todoItems.count && isCompletedShowing) || (indexPath.row == notCompletedTodoItems.count && !isCompletedShowing) {
            return nil
        }

        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completion) in
            guard let self = self else { return }
            var todoItem: TodoItem
            if isCompletedShowing {
                todoItem = self.todoItems[indexPath.row]
            } else {
                todoItem = self.notCompletedTodoItems[indexPath.row]
            }
            self.deleteTodo(todoItem: todoItem)
            completion(true)
        }

        action.image = UIImage(named: "deleteAction")
        action.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [action])
    }

    // Анимация при нажатии на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4) {
            let selectedCell = tableView.cellForRow(at: indexPath)
            selectedCell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                let selectedCell = tableView.cellForRow(at: indexPath)
                selectedCell?.transform = .identity
                tableView.deselectRow(at: indexPath, animated: true)
            }

            self.openEditTodo(indexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            // Создайте действия контекстного меню
            guard tableView.cellForRow(at: indexPath) is CustomTableViewCell else { return nil }
            let action1 = UIAction(title: "Выполнить", image: UIImage(systemName: "checkmark.circle.fill")) { _ in
                self.updateCompletition(todoItem: self.getCurrentTodoItem(indexPath: indexPath))
            }

            let action2 = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.openEditTodo(indexPath: indexPath)
            }

            let action3 = UIAction(title: "Удалить", image: UIImage(systemName: "trash.fill")) { _ in
                self.deleteTodo(todoItem: self.getCurrentTodoItem(indexPath: indexPath))
            }

            // Создайте меню с действиями
            let menu = UIMenu(title: "Дополнительные действия", children: [action1, action2, action3])

            return menu
        }

        return configuration
    }

}

// MARK: Методы для скругления ячеек

extension UITableView {
    func isFirstRow(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == 0
    }

    func isLastRow(_ indexPath: IndexPath) -> Bool {
        let lastSectionIndex = numberOfSections - 1
        let lastRowIndex = numberOfRows(inSection: lastSectionIndex) - 1
        return indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

// MARK: CustomTableViewCellDelegate

extension TodoListView: CustomTableViewCellDelegate {
    func saveTodo(_ todo: TodoItem) {
        delegate?.saveTodo(todo)
    }
}

// MARK: HeaderTableViewDelegate

extension TodoListView: HeaderTableViewDelegate {
    func showButtonDidTapped() {
        isCompletedShowing.toggle()
        let vc = delegate as? TodoListViewController
        vc?.updateData()
    }
}

// MARK: Configuration of View

extension TodoListView {
    func updateData(todoItems: [TodoItem]) {
        self.todoItems = todoItems
        self.notCompletedTodoItems = todoItems.filter({!$0.isCompleted})
        tableView.reloadData()
        headerTableView.updateTitleLabel(to: todoItems.filter({$0.isCompleted}).count)
    }

    private func setupView() {
        backgroundColor = .backPrimary

        addSubview(tableView)
        addSubview(creatureButton)

        tableView.tableHeaderView = headerTableView
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            creatureButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            creatureButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            creatureButton.widthAnchor.constraint(equalToConstant: 44),
            creatureButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

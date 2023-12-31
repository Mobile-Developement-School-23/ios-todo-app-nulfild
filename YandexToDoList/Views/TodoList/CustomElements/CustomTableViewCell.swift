//
//  CustomTableViewCell.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 29.06.2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    weak var delegate: CustomTableViewCellDelegate?
    static let identifier = "CustomCell"
    private var todoItem: TodoItem?

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(doneButtonDidTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let allStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 7
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var importanceImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var textTodoLabel: UILabel = {
        let label = UILabel()
        label.text = "Купить сыр"
        label.font = .body
        label.textColor = .labelPrimary
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dateStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 3.5
        stack.isHidden = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var calendarImageView: UIImageView = {
        let image = UIImage(systemName: "calendar",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 13))

        let view = UIImageView()
        view.image = image
        view.tintColor = .supportSeparator
        view.widthAnchor.constraint(equalToConstant: 13).isActive = true
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "23 июля"
        label.font = .subhead
        label.textColor = .labelTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var arrowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "arrow")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func doneButtonDidTapped() {
        guard let todoItem else { fatalError("Error") }
        if doneButton.isSelected {
            updateButton(with: todoItem)
        } else {
            doneButton.setImage(UIImage(named: "doneButtonOn"), for: .normal)
        }
        doneButton.isSelected.toggle()
        delegate?.saveTodo(TodoItem(id: todoItem.id,
                                    text: todoItem.text,
                                    importance: todoItem.importance,
                                    deadline: todoItem.deadline,
                                    isCompleted: !todoItem.isCompleted,
                                    createDate: todoItem.createDate,
                                    editDate: todoItem.editDate))
    }

}

// MARK: Confriguration of View

extension CustomTableViewCell {
    private func setupView() {
        contentView.addSubview(doneButton)
        contentView.addSubview(allStackView)
        allStackView.addArrangedSubview(textStackView)
        allStackView.addArrangedSubview(dateStackView)

        textStackView.addArrangedSubview(importanceImageView)
        textStackView.addArrangedSubview(textTodoLabel)

        dateStackView.addArrangedSubview(calendarImageView)
        dateStackView.addArrangedSubview(dateLabel)
        contentView.addSubview(arrowImage)
    }

    func configure(with todo: TodoItem?) {
        todoItem = todo
        guard let todoItem else { fatalError("Error") }
        if todoItem.isCompleted {
            textTodoLabel.attributedText = todoItem.text.strikedText
        } else {
            textTodoLabel.attributedText = todoItem.text.attributedString
        }
        updateButton(with: todoItem)

        switch todoItem.importance {
        case .low:
            importanceImageView.image = UIImage(named: "low")
            importanceImageView.isHidden = false
        case .normal:
            importanceImageView.isHidden = true
        case .important:
            importanceImageView.image = UIImage(named: "important")
            importanceImageView.isHidden = false
        }

        if let deadline = todoItem.deadline {
            dateStackView.isHidden = false
            dateLabel.text = deadline.toStringWithoutYear
        } else {
            dateStackView.isHidden = true
        }

        setConstraints()
    }

    func updateButton(with todo: TodoItem?) {
        guard let todo else { fatalError("Error") }
        if todo.isCompleted {
            doneButton.setImage(UIImage(named: "doneButtonOn"), for: .normal)
            doneButton.isSelected = true
        } else {
            if todo.importance == .important {
                doneButton.setImage(UIImage(named: "doneButtonImportant"), for: .normal)
            } else {
                let image = UIImage(named: "doneButton")
                let tint = UIColor.supportSeparator.withAlphaComponent(1)
                doneButton.setImage(image?.withTintColor(tint), for: .normal)
            }
        }
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            doneButton.widthAnchor.constraint(equalToConstant: 24),
            doneButton.heightAnchor.constraint(equalToConstant: 24),

            allStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            allStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            allStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            allStackView.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 12),
            allStackView.trailingAnchor.constraint(equalTo: arrowImage.trailingAnchor, constant: -16),

            importanceImageView.widthAnchor.constraint(equalToConstant: 11),

            arrowImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImage.widthAnchor.constraint(equalToConstant: 7),
            arrowImage.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
}

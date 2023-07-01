//
//  NewTodoTableViewCell.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 01.07.2023.
//

import UIKit

class NewTodoTableViewCell: UITableViewCell {
    
    static let identifier = "NewTodoCell"
    
    private lazy var titleLabel: UILabel = {
        let label = CustomLabel(text: "Новое")
        label.textColor = .labelTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewTodoTableViewCell {
    private func setupView() {
        contentView.addSubview(titleLabel)
        separatorInset = UIEdgeInsets(top: 0, left: 9999, bottom: 0, right: 0)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 52),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
}

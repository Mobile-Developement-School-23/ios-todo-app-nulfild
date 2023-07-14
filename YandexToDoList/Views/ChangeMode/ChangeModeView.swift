//
//  ChangeModeView.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 15.07.2023.
//

import UIKit

class ChangeModeView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = CustomLabel(text: "Какой режим выбрать?")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(frame: .zero)

        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChangeModeView {
    private func setupView() {
        backgroundColor = .backPrimary
        addSubview(titleLabel)

//        addSubview(tableView)
//        addSubview(creatureButton)
//        addSubview(settingsButton)

    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

//
//  ChangeModeView.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 15.07.2023.
//

import UIKit

class ChangeModeView: UIView {
    weak var delegate: ChangeModeViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = CustomLabel(text: "Какой режим выбрать?")
        label.font = .body.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sqlButton: UIButton = {
        let button = UIButton()
        button.setTitle("SQLite ♻️", for: .normal)
        button.setTitleColor(.labelPrimary, for: .normal)
        button.backgroundColor = .backSecondary
        button.layer.cornerRadius = 6
        button.addTarget(nil, action: #selector(sqlButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var coreDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("CoreData 🛠️", for: .normal)
        button.setTitleColor(.labelPrimary, for: .normal)
        button.backgroundColor = .backSecondary
        button.layer.cornerRadius = 6
        button.addTarget(nil, action: #selector(coreDataButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init() {
        super.init(frame: .zero)

        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func sqlButtonDidTapped() {
        delegate?.sqlButtonDidTapped()
    }
    
    @objc private func coreDataButtonDidTapped() {
        delegate?.coreDataButtonDidTapped()
    }
    
    func updateColorOfButtons(isSQLInUse: Bool) {
        if isSQLInUse {
            sqlButton.backgroundColor = .green
            coreDataButton.backgroundColor = .backSecondary
        } else {
            sqlButton.backgroundColor = .backSecondary
            coreDataButton.backgroundColor = .green
        }
    }
}

extension ChangeModeView {
    private func setupView() {
        backgroundColor = .backPrimary
        addSubview(titleLabel)
        addSubview(sqlButton)
        addSubview(coreDataButton)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            sqlButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 50),
            sqlButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            sqlButton.widthAnchor.constraint(equalToConstant: 130),
            sqlButton.heightAnchor.constraint(equalToConstant: 50),
            
            coreDataButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -50),
            coreDataButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            coreDataButton.widthAnchor.constraint(equalToConstant: 130),
            coreDataButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

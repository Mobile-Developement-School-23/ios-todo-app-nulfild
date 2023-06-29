//
//  TodoListView.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 28.06.2023.
//

import UIKit

class TodoListView: UIView {
    var delegate: TodoListViewDelegate?
    
    private lazy var creatureButton: UIButton = {
        let button = UIButton(type: .system)
//        button.backgroundColor = .red
        button.addTarget(nil, action: #selector(creatureButtonDidTapped), for: .touchUpInside)
        button.layer.cornerRadius = 0.5 * 44
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(named: "Low"), for: .normal)
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
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
    
    @objc func creatureButtonDidTapped() {
        delegate?.creatureButtonDidTapped()
    }
}

extension TodoListView {
    private func setupView() {
        backgroundColor = .backPrimary
        
        addSubview(creatureButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            creatureButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            creatureButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            creatureButton.widthAnchor.constraint(equalToConstant: 44),
            creatureButton.heightAnchor.constraint(equalToConstant: 44),

        ])
    }
}

//
//  ViewController.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 15.06.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let creationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("test", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(nil, action: #selector(creationButtonDidTapped), for: .touchUpInside)
        button.layer.cornerRadius = 0.5 * 44
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let creationViewController = CreationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()

        let fc = FileCache()
        try? fc.loadFromJson(from: "TodoItems")
        creationViewController.todoItem = fc.items.first?.value
    }
    
    
    func setupView() {
        view.backgroundColor = .backPrimary
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Мои дела"
        view.addSubview(creationButton)
    }

    
    @objc func creationButtonDidTapped() {
        let test = UINavigationController(rootViewController: creationViewController)
        creationViewController.checkTodoItem()
        present(test, animated: true)
    }
    
}

extension ViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            creationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            creationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            creationButton.widthAnchor.constraint(equalToConstant: 44),
            creationButton.heightAnchor.constraint(equalToConstant: 44),
            
        ])
    }
}

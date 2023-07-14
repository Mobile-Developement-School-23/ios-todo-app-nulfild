//
//  ChangeModeViewController.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 15.07.2023.
//

import UIKit

class ChangeModeViewController: UIViewController {
    private var changeModeView: ChangeModeView?
    weak var delegate: TodoListViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}

extension ChangeModeViewController {
    private func setupView() {
        changeModeView = ChangeModeView()
        view = changeModeView
    }
}

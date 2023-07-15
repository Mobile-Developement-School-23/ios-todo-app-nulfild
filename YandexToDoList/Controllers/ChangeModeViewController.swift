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

extension ChangeModeViewController: ChangeModeViewDelegate {
    func sqlButtonDidTapped() {
        delegate?.isSQLInUse = true
        delegate?.loadData()
        changeModeView?.updateColorOfButtons(isSQLInUse: delegate?.isSQLInUse ?? false)
        dismiss(animated: true)
    }
    
    func coreDataButtonDidTapped() {
        delegate?.isSQLInUse = false
        delegate?.loadData()
        changeModeView?.updateColorOfButtons(isSQLInUse: delegate?.isSQLInUse ?? false)
        dismiss(animated: true)
    }
}

extension ChangeModeViewController {
    private func setupView() {
        changeModeView = ChangeModeView()
        changeModeView?.delegate = self
        view = changeModeView
        changeModeView?.updateColorOfButtons(isSQLInUse: delegate?.isSQLInUse ?? false)
    }
}

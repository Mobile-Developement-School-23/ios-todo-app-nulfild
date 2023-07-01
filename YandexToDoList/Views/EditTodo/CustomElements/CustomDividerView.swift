//
//  CustomDividerView.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 26.06.2023.
//

import UIKit

class CustomDividerView: UIView {

    init() {
        super.init(frame: .zero)

        setupView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CustomDividerView {
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .supportSeparator
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }
}

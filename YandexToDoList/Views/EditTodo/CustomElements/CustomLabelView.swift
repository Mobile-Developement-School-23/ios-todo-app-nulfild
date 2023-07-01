//
//  CustomLabelView.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 26.06.2023.
//

import UIKit

class CustomLabel: UILabel {

    init(text: String) {
        super.init(frame: .zero)

        self.text = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomLabel {
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        font = .body
        textColor = .labelPrimary
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}

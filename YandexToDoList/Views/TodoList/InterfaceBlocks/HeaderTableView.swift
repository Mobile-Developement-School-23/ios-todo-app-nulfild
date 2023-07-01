//
//  HeaderTableView.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 29.06.2023.
//

import UIKit

class HeaderTableView: UIView {
    
    weak var delegate: HeaderTableViewDelegate?
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Выполнено — 5"
        label.textColor = .labelTertiary
        label.font = .subhead
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var showButton: UIButton = {
        let button = UIButton()
        button.setTitle("Показать", for: .normal)
        button.isSelected = false
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .subheadBold
        button.addTarget(self,
                         action: #selector(showButtonDidTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTitleLabel(to num: Int) {
        textLabel.text = "Выполнено — \(num)"
    }
    
    @objc private func showButtonDidTapped() {
        showButton.isSelected.toggle()
        showButton.isSelected ? showButton.setTitle("Cкрыть", for: .normal) : showButton.setTitle("Показать", for: .normal)
        delegate?.showButtonDidTapped()
    }
    
}

// MARK: Configuration of View

extension HeaderTableView {
    private func setupView() {
        addSubview(textLabel)
        addSubview(showButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            showButton.heightAnchor.constraint(equalToConstant: 20),
            showButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            showButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}

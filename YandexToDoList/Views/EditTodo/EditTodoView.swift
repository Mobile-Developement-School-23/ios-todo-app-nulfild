//
//  EditTodoView.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 26.06.2023.
//

import UIKit

class EditTodoView: UIView {
    
    var todoItem: TodoItem?
    var keyboardHeight: CGFloat = 0
    
    weak var delegate: EditTodoViewDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .backPrimary
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 12, right: 16)
        textView.backgroundColor = .backSecondary
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 16
        textView.font = .body
        textView.text = "Что надо сделать?"
        textView.textColor = .labelTertiary
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var textViewHeightConstraint: NSLayoutConstraint?
    
    lazy var optionsTodoView = OptionsTodoView()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(.labelTertiary, for: .disabled)
        button.titleLabel?.font = .body
        button.backgroundColor = .backSecondary
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(deleteButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(todoItem: TodoItem?) {
        super.init(frame: .zero)
        
        self.todoItem = todoItem
        optionsTodoView.delegate = self
        setupView()
        setConstraints()
        updateViewWithTodoItem()
        configureGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if frame.width > frame.height {
            textViewHeightConstraint?.constant = frame.height - 76
        } else {
            textViewHeightConstraint?.constant = 120
        }
    }
    
    @objc func deleteButtonDidTapped() {
        if let todoItem {
            delegate?.deleteButtonDidTapped(todoItem)
        } else {
            fatalError("ERROR")
        }
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc func keyboardDidShow(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardRectangle.height
            scrollView.contentInset = UIEdgeInsets(
                top: 0, left: 0, bottom: keyboardHeight, right: 0
            )
        }
    }
}

// MARK: UITextViewDelegate

extension EditTodoView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.textDidBeginEditing(textView: textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textDidChange(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textDidEndEditing(textView: textView)
        
        scrollView.contentInset = UIEdgeInsets(
            top: 0, left: 0, bottom: 0, right: 0
        )
    }
}

// MARK: Configuration View

extension EditTodoView {
    private func setupView() {
        addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(optionsTodoView)
        stackView.addArrangedSubview(deleteButton)
    }
    
    private func updateViewWithTodoItem() {
        // TODO: Проверить загрузки экрана с Todo Item'ом
        guard let todoItem else {
            return
        }
        textView.text = todoItem.text
        textView.textColor = .labelPrimary

        if todoItem.importance == .low {
            optionsTodoView.segmentControl.selectedSegmentIndex = 0
        } else if todoItem.importance == .normal {
            optionsTodoView.segmentControl.selectedSegmentIndex = 1
        } else {
            optionsTodoView.segmentControl.selectedSegmentIndex = 2
        }

        if let deadline = todoItem.deadline {
            optionsTodoView.datePicker.date = deadline
            optionsTodoView.deadlineButton.setTitle(deadline.toString, for: .normal)
            optionsTodoView.deadlineSwitch.isOn = true
            optionsTodoView.showDeadlineButton(bool: true)
        }
//        saveButton?.tintColor = .blue

        deleteButton.isEnabled = true
    }
    
    private func configureGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false

        scrollView.addGestureRecognizer(tap)
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardDidShow(keyboardShowNotification:)),
                         name: UIResponder.keyboardDidShowNotification,
                         object: nil)
    }
    
    private func setConstraints() {
        textViewHeightConstraint = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        textViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -keyboardHeight),
            
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}


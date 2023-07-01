//
//  OptionsTodoView.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 28.06.2023.
//

import UIKit

class OptionsTodoView: UIView {

    weak var delegate: EditTodoView?
    var todoItem: TodoItem?

    private lazy var allItemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .clear
        return stackView
    }()

    private lazy var deadlineStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalCentering
        stack.spacing = 0
        return stack
    }()

    private lazy var importanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var importanceLabel = CustomLabel(text: "Важность")

    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["", "нет", ""])
        let lowImage = UIImage(named: "low")
        let importantImage = UIImage(named: "important")

        segment.setImage(lowImage, forSegmentAt: 0)
        segment.setImage(importantImage, forSegmentAt: 2)
        //        segment.backgroundColor = .supportOverlayColorForSwitch
        segment.selectedSegmentIndex = 1
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()

    private lazy var divider1 = CustomDividerView()
    private lazy var divider2 = CustomDividerView()

    private lazy var stackViewDeadline: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var deadlineLabel = CustomLabel(text: "Сделать до")

    lazy var deadlineSwitch: UISwitch = {
        let deadlineSwitch = UISwitch()
        deadlineSwitch.addTarget(self, action: #selector(deadlineDidSwitch), for: .valueChanged)
        return deadlineSwitch
    }()

    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.backgroundColor = .backSecondary
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "Ru_ru")
        picker.calendar.firstWeekday = 2
        picker.addTarget(
            self,
            action: #selector(datePickerValueChanged),
            for: .valueChanged
        )
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = true
        return picker
    }()

    lazy var deadlineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("23 июля 2003", for: .normal)
        button.addTarget(self, action: #selector(deadlineButtonDidTapped), for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)
        button.isHidden = true
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: init()

    override init(frame: CGRect) {
        super.init(frame: frame)

        todoItem = delegate?.todoItem

        setupView()
        setConstraints()
        updateViewWithTodoItem()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func deadlineDidSwitch() {
        showDeadlineButton(bool: true)

        if !deadlineSwitch.isOn && !datePicker.isHidden {
            deadlineButtonDidTapped()
        } else if deadlineSwitch.isOn {
            deadlineButton.setTitle(datePicker.date.toString, for: .normal)
        }
    }

    func showDeadlineButton(bool: Bool) {
        if bool {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                guard let self = self else { return }
                self.deadlineButton.alpha = deadlineSwitch.isOn ? 1.0 : 0.0
                self.deadlineButton.isHidden = deadlineSwitch.isOn ? false : true
            })
        } else {
            self.deadlineButton.alpha = 0
            self.deadlineButton.isHidden = true
        }
    }

    @objc func deadlineButtonDidTapped() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else { return }
            self.setDefaultDatePicker()
        })
    }

    private func setupDate() {
        let calendar = Calendar.current
        datePicker.minimumDate = calendar.startOfDay(for: Date())
        if let nextDay = calendar.date(byAdding: .day, value: 1, to: Date()) {
            datePicker.date = nextDay
        }
    }

    @objc private func datePickerValueChanged() {
        deadlineButton.setTitle(datePicker.date.toString, for: .normal)
    }

    private func setDefaultDatePicker() {
        datePicker.isHidden = datePicker.isHidden ? false : true

        divider2.isHidden = divider2.isHidden ? false : true
        divider2.alpha = divider2.isHidden ? 0.0 : 1.0

        // TODO: сделать opacity для фикса артефакта
    }
}

// MARK: Configuration of View

extension OptionsTodoView {
    private func updateViewWithTodoItem() {
        setupDate()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .backSecondary
        layer.cornerRadius = 16
        divider2.isHidden = true

        addSubview(allItemsStackView)

        allItemsStackView.addArrangedSubview(importanceStackView)
        importanceStackView.addArrangedSubview(importanceLabel)
        importanceStackView.addArrangedSubview(segmentControl)
        allItemsStackView.addArrangedSubview(divider1)

        stackViewDeadline.addArrangedSubview(deadlineStackView)
        deadlineStackView.addArrangedSubview(deadlineLabel)
        deadlineStackView.addArrangedSubview(deadlineButton)
        stackViewDeadline.addArrangedSubview(deadlineSwitch)
        allItemsStackView.addArrangedSubview(stackViewDeadline)
        allItemsStackView.addArrangedSubview(divider2)
        allItemsStackView.addArrangedSubview(datePicker)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            allItemsStackView.topAnchor.constraint(equalTo: topAnchor),
            allItemsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            allItemsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            allItemsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            importanceStackView.heightAnchor.constraint(equalToConstant: 56),

            segmentControl.widthAnchor.constraint(equalToConstant: 150),
            segmentControl.heightAnchor.constraint(equalToConstant: 36),

            stackViewDeadline.heightAnchor.constraint(equalToConstant: 56),

            deadlineButton.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

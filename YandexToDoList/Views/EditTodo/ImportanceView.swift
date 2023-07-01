//
//  ImportanceView.swift
//  YandexToDoList
//
//  Created by Герман Кунин on 24.06.2023.
//

import UIKit

class ImportanceView: UIView {

    var deadline: Date?

    private lazy var stackViewAll: UIStackView = {
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

    private lazy var stackViewImportance: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var importanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        label.font = .body
        label.tintColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["", "нет", ""])
        let lowImage = UIImage(named: "Low")
        let importantImage = UIImage(named: "Important")

        segment.setImage(lowImage, forSegmentAt: 0)
        segment.setImage(importantImage, forSegmentAt: 2)
        //        segment.backgroundColor = .supportOverlayColorForSwitch
        segment.selectedSegmentIndex = 1
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()

    private lazy var divider1: UIView = {
        let view = UIView()
        view.backgroundColor = .supportSeparator
        return view
    }()
    private lazy var divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .supportSeparator
        view.isHidden = true
        view.alpha = 0
        return view
    }()

    private lazy var stackViewDeadline: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Сделать до"
        label.font = .body
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
        picker.isHidden = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    lazy var deadlineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("25 июня 2021", for: .normal)
        button.addTarget(self, action: #selector(deadlineButtonDidTapped), for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)
        button.isHidden = true
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
        setupDate()
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
        guard deadline == nil else { return }
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
        setupDate()

        self.datePicker.isHidden = datePicker.isHidden ? false : true
        self.divider2.isHidden = divider2.isHidden ? false : true
        self.divider2.alpha = divider2.isHidden ? 0.0 : 1.0
    }

    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .backSecondary
        layer.cornerRadius = 16

        addSubview(stackViewAll)

        stackViewAll.addArrangedSubview(stackViewImportance)
        stackViewImportance.addArrangedSubview(importanceLabel)
        stackViewImportance.addArrangedSubview(segmentControl)
        stackViewAll.addArrangedSubview(divider1)

        stackViewDeadline.addArrangedSubview(deadlineStackView)
        deadlineStackView.addArrangedSubview(deadlineLabel)
        deadlineStackView.addArrangedSubview(deadlineButton)
        stackViewDeadline.addArrangedSubview(deadlineSwitch)
        stackViewAll.addArrangedSubview(stackViewDeadline)
        stackViewAll.addArrangedSubview(divider2)
        stackViewAll.addArrangedSubview(datePicker)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            stackViewAll.topAnchor.constraint(equalTo: topAnchor),
            stackViewAll.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16), // 16
            stackViewAll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12), // -12
            stackViewAll.bottomAnchor.constraint(equalTo: bottomAnchor),

            //            stackViewImportance.heightAnchor.constraint(equalToConstant: 56),

            stackViewImportance.heightAnchor.constraint(equalToConstant: 56),

            segmentControl.widthAnchor.constraint(equalToConstant: 150),
            segmentControl.heightAnchor.constraint(equalToConstant: 36),

            stackViewDeadline.heightAnchor.constraint(equalToConstant: 56),

            deadlineLabel.heightAnchor.constraint(equalToConstant: 22),
            deadlineButton.heightAnchor.constraint(equalToConstant: 18),

            divider1.heightAnchor.constraint(equalToConstant: 0.666),
            divider2.heightAnchor.constraint(equalToConstant: 0.666)
        ])
    }

}

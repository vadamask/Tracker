//
//  TrackerSetupViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 29.08.2023.
//

import UIKit

protocol TrackerSetupViewControllerDelegate: AnyObject {
    func didCreateTrackerWith(_ category: TrackerCategory)
}

final class TrackerSetupViewController: UIViewController {
    
    weak var delegate: TrackerSetupViewControllerDelegate?
    private var isTracker: Bool
    private var scheduleIsSet: Bool = false {
        didSet {
            checkCreateButtonActivation(textField.text)
        }
    }
    
    private var schedule =  [
        WeekDay(fullName: "Понедельник", shortName: "Пн", isOn: false),
        WeekDay(fullName: "Вторник", shortName: "Вт", isOn: false),
        WeekDay(fullName: "Среда", shortName: "Ср", isOn: false),
        WeekDay(fullName: "Четверг", shortName: "Чт", isOn: false),
        WeekDay(fullName: "Пятница", shortName: "Пт", isOn: false),
        WeekDay(fullName: "Суббота", shortName: "Сб", isOn: false),
        WeekDay(fullName: "Воскресенье", shortName: "Вс", isOn: false)
    ]
    
    private var topLabel: UILabel!
    
    private let createButton: UIButton = {
        let button = UIButton(title: "Создать", backgroundColor: .grayYP)
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(title: "Отменить", textColor: .redYP, backgroundColor: .clear)
        button.layer.borderColor = UIColor.redYP.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = 75
        tableView.backgroundColor = .whiteYP
        return tableView
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .always
        textField.backgroundColor = .backgroundYP
        textField.layer.cornerRadius = 16
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.returnKeyType = .done
        return textField
    }()
    
    init(delegate: TrackerSetupViewControllerDelegate?, isTracker: Bool) {
        self.delegate = delegate
        self.isTracker = isTracker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        self.hideKeyboardWhenTappedAround()
        
        topLabel = isTracker ? UILabel(title: "Новая привычка") : UILabel(title: "Новое нерегулярное событие")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackerSetupCell.self, forCellReuseIdentifier: "cell")
        
        textField.delegate = self
        textField.becomeFirstResponder()
    }
    
    private func setupConstraints() {
        view.addSubview(topLabel)
        view.addSubview(tableView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 38),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        let category = TrackerCategory(
            title: "Title category",
            trackers: [Tracker(id: UUID(), name: textField.text!, color: "Color selection 0", emoji: "🤬", schedule: schedule)])
        delegate?.didCreateTrackerWith(category)
    }
    
    private func checkCreateButtonActivation(_ text: String?) {
        if let text = text, !text.isEmpty, scheduleIsSet {
            createButton.isEnabled = true
            createButton.backgroundColor = .blackYP
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .grayYP
        }
    }
}

// MARK: - UITableViewDataSource

extension TrackerSetupViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isTracker ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = indexPath.row == 0 ? "Категория" : "Расписание"
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate

extension TrackerSetupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            
        } else {
            let vc = TrackerScheduleViewController(delegate: self, schedule: schedule)
            present(vc, animated: true)
        }
    }
}

// MARK: - ScheduleViewControllerDelegate

extension TrackerSetupViewController: TrackerScheduleViewControllerDelegate {
    func didSelectedDays(in schedule: [WeekDay]) {
        self.schedule = schedule
        let selectedDays = schedule
            .filter { $0.isOn == true }
            .map { $0.shortName }
        scheduleIsSet = selectedDays.isEmpty ? false : true
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.detailTextLabel?.text = selectedDays.count < 7 ? selectedDays.joined(separator: ", ") : "Каждый день"
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension TrackerSetupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        checkCreateButtonActivation(updatedText)
        return updatedText.count <= 38
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkCreateButtonActivation("")
        return true
    }
}

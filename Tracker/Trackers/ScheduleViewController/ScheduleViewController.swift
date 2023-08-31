//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 29.08.2023.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func daysDidSelected(_ days: String)
}

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private var days: [WeekDay] = [
        WeekDay(fullName: "Понедельник", shortName: "Пн"),
        WeekDay(fullName: "Вторник", shortName: "Вт"),
        WeekDay(fullName: "Среда", shortName: "Ср"),
        WeekDay(fullName: "Четверг", shortName: "Чт"),
        WeekDay(fullName: "Пятница", shortName: "Пт"),
        WeekDay(fullName: "Суббота", shortName: "Сб"),
        WeekDay(fullName: "Воскресенье", shortName: "Вс")
    ]
    
    private let topLabel = UILabel(title: "Расписание")
    
    private let scheduleTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = 75
        tableView.backgroundColor = .whiteYP
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(title: "Готово")
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        scheduleTableView.dataSource = self
        scheduleTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupConstraints() {
        view.addSubview(topLabel)
        view.addSubview(scheduleTableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scheduleTableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor),
            scheduleTableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func doneButtonTapped() {
        let selectedDays = days
            .filter { $0.isOn == true }
            .map { $0.shortName }
        
        selectedDays.count < 7 ?
        delegate?.daysDidSelected(selectedDays.joined(separator: ", ")) :
        delegate?.daysDidSelected("Каждый день")
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ScheduleTableViewCell {
            cell.textLabel?.text = days[indexPath.row].fullName
            cell.delegate = self
            cell.configure(at: indexPath.row)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - ScheduleTableViewCellDelegate

extension ScheduleViewController: ScheduleTableViewCellDelegate {
    func switchDidTapped(_ isOn: Bool, at row: Int) {
        days[row].isOn = isOn
    }
}

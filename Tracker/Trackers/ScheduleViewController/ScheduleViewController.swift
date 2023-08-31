//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 29.08.2023.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelected(_ schedule: [WeekDay])
}

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private var schedule: [WeekDay] = []
    
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
    
    init(delegate: ScheduleViewControllerDelegate, schedule: [WeekDay]) {
        self.delegate = delegate
        self.schedule = schedule
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
        delegate?.didSelected(schedule)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ScheduleTableViewCell {
            cell.textLabel?.text = schedule[indexPath.row].fullName
            cell.delegate = self
            cell.configure(at: indexPath.row, isOn: schedule[indexPath.row].isOn)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - ScheduleTableViewCellDelegate

extension ScheduleViewController: ScheduleTableViewCellDelegate {
    func switchDidTapped(_ isOn: Bool, at row: Int) {
        schedule[row].isOn = isOn
    }
}

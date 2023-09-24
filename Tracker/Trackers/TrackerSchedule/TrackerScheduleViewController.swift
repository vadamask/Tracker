//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 29.08.2023.
//

import SnapKit
import UIKit

protocol TrackerScheduleViewControllerDelegate: AnyObject {
    func didSelectedDays(in schedule: Set<WeekDay>)
}

final class TrackerScheduleViewController: UIViewController {
    
    weak var delegate: TrackerScheduleViewControllerDelegate?
    
    private var schedule: Set<WeekDay>
    private let topLabel = UILabel(text: "Расписание", textColor: .blackYP, font: .systemFont(ofSize: 16, weight: .medium))
    private let doneButton = UIButton(title: "Готово")
    private let tableView = UITableView()
    
    init(delegate: TrackerScheduleViewControllerDelegate?, schedule: Set<WeekDay>) {
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
        setupLayout()
    }
    
    @objc private func doneButtonTapped() {
        delegate?.didSelectedDays(in: schedule)
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        
        tableView.dataSource = self
        tableView.register(TrackerScheduleTableViewCell.self, forCellReuseIdentifier: "cell")
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = 75
        tableView.backgroundColor = .whiteYP
        tableView.allowsSelection = false
        tableView.layer.cornerRadius = 16
    }
    
    private func setupLayout() {
        view.addSubview(topLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(27)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(30)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(47)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(60)
        }
    }
}

// MARK: - UITableViewDataSource

extension TrackerScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TrackerScheduleTableViewCell {
            cell.textLabel?.text = WeekDay.fullName(for: indexPath.row)
            cell.delegate = self
            if let day = WeekDay(rawValue: indexPath.row) {
                cell.configure(at: indexPath.row, isOn: schedule.contains(day))
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - ScheduleTableViewCellDelegate

extension TrackerScheduleViewController: TrackerScheduleTableViewCellDelegate {
    func switchDidTapped(_ isOn: Bool, at row: Int) {
        if let day = WeekDay(rawValue: row) {
            if isOn {
                schedule.insert(day)
            } else {
                schedule.remove(day)
            }
        }
    }
}

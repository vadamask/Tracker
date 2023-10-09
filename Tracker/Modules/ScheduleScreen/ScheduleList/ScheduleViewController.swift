//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 29.08.2023.
//

import SnapKit
import UIKit

final class ScheduleViewController: UIViewController {
    
    var completion: ((Set<WeekDay>) -> Void)?
    
    private var viewModel: ScheduleViewModel
    
    private var schedule: Set<WeekDay> = []
    private let topLabel = UILabel()
    private let doneButton = UIButton(type: .system)
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
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
        dismiss(animated: true)
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        
        topLabel.text = L10n.Localizable.ScheduleScreen.TopLabel.title
        topLabel.textColor = .blackYP
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        tableView.dataSource = self
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: "cell")
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.setTitle(L10n.Localizable.ScheduleScreen.doneButtonTitle, for: .normal)
        doneButton.setTitleColor(.whiteYP, for: .normal)
        doneButton.backgroundColor = .blackYP
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.layer.cornerRadius = 16
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
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
            make.top.equalTo(topLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
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

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ScheduleCell else { return UITableViewCell() }
        cell.viewModel = viewModel.viewModel(at: indexPath)
        cell.completion = { [weak self] in
            self?.completion?(self?.viewModel.selectedDays ?? [])
        }
        return cell
    }
}



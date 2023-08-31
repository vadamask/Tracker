//
//  TrackerSetupViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 29.08.2023.
//

import UIKit

final class TrackerSetupViewController: UIViewController {
    
    var isTracker: Bool!
    
    
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
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        
        topLabel = isTracker ? UILabel(title: "Новая привычка") : UILabel(title: "Новое нерегулярное событие")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackerSetupCell.self, forCellReuseIdentifier: "cell")
        
        textField.delegate = self
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
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
        
    }
}

// MARK: - UITableViewDataSource

extension TrackerSetupViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isTracker ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.backgroundColor = .backgroundYP
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = indexPath.row == 0 ? "Категория" : "Расписание"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            cell.textLabel?.textColor = .blackYP
            cell.layer.cornerRadius = 16
            cell.detailTextLabel?.textColor = .grayYP
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
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
            let vc = ScheduleViewController()
            vc.delegate = self
            present(vc, animated: true)
        }
    }
}

// MARK: - ScheduleViewControllerDelegate

extension TrackerSetupViewController: ScheduleViewControllerDelegate {
    func daysDidSelected(_ days: String) {
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.detailTextLabel?.text = days
    }
}

// MARK: - UITextFieldDelegate

extension TrackerSetupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        return updatedText.count <= 38
    }
    
    
}

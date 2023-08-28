//
//  ForkViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import UIKit

final class ForkViewController: UIViewController {
    
    private let trackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blackYP
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(.whiteYP, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let eventButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blackYP
        button.setTitle("Нерегулярное событие", for: .normal)
        button.setTitleColor(.whiteYP, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let titleLabel = UILabel(title: "Создание трекера")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
    }
    
    private func setupConstraints() {
        view.addSubview(trackerButton)
        view.addSubview(eventButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            trackerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            trackerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trackerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 295),
            trackerButton.heightAnchor.constraint(equalToConstant: 60),
            
            eventButton.leadingAnchor.constraint(equalTo: trackerButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: trackerButton.trailingAnchor),
            eventButton.topAnchor.constraint(equalTo: trackerButton.bottomAnchor, constant: 16),
            eventButton.heightAnchor.constraint(equalTo: trackerButton.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

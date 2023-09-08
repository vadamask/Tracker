//
//  ForkViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import UIKit

protocol TrackerTypeViewControllerDelegate: AnyObject {
    func didCreateTrackerWith(_ category: TrackerCategory)
}

final class TrackerTypeViewController: UIViewController {
    
    weak var delegate: TrackerTypeViewControllerDelegate?
    
    private let topLabel = UILabel(text: "Создание трекера", textColor: .blackYP, font: .systemFont(ofSize: 16, weight: .medium))
    
    private let trackerButton: UIButton = {
        let button = UIButton(title: "Привычка")
        button.addTarget(self, action: #selector(trackerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let eventButton: UIButton = {
        let button = UIButton(title: "Нерегулярное событие")
        button.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(delegate: TrackerTypeViewControllerDelegate?) {
        self.delegate = delegate
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
    }
    
    private func setupConstraints() {
        view.addSubview(trackerButton)
        view.addSubview(eventButton)
        view.addSubview(topLabel)
        
        NSLayoutConstraint.activate([
            trackerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            trackerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trackerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackerButton.heightAnchor.constraint(equalToConstant: 60),
            
            eventButton.leadingAnchor.constraint(equalTo: trackerButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: trackerButton.trailingAnchor),
            eventButton.topAnchor.constraint(equalTo: trackerButton.bottomAnchor, constant: 16),
            eventButton.heightAnchor.constraint(equalTo: trackerButton.heightAnchor),
            
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func trackerButtonTapped(sender: Any) {
        let vc = TrackerSetupViewController(delegate: self, isTracker: true)
        present(vc, animated: true)
    }
    
    @objc private func eventButtonTapped() {
        let vc = TrackerSetupViewController(delegate: self, isTracker: false)
        present(vc, animated: true)
    }
}

extension TrackerTypeViewController: TrackerSetupViewControllerDelegate {
    func didCreateTrackerWith(_ category: TrackerCategory) {
        delegate?.didCreateTrackerWith(category)
    }
}

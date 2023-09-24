//
//  ForkViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import UIKit

protocol TrackerTypeViewControllerDelegate: AnyObject {
    func didTapCancelButton()
    func didCreate(_ tracker: Tracker, with title: String)
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
        let vc = TrackerSetupViewController(isTracker: true)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func eventButtonTapped() {
        let vc = TrackerSetupViewController(isTracker: false)
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: - TrackerSetupViewControllerDelegate

extension TrackerTypeViewController: TrackerSetupViewControllerDelegate {
    func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }
    
    func didCreate(_ tracker: Tracker, with title: String) {
        delegate?.didCreate(tracker, with: title)
    }
    
    
}

//
//  ForkViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import SnapKit
import UIKit

protocol NewTrackerViewControllerDelegate: AnyObject {
    func dismiss()
}

final class NewTrackerViewController: UIViewController {
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
    private let topLabel = UILabel()
    private let trackerButton = UIButton()
    private let eventButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        
        topLabel.text = NSLocalizedString("newTracker.topLabel", comment: "Top label on screen")
        topLabel.textColor = .blackYP
        topLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        trackerButton.addTarget(self, action: #selector(trackerButtonTapped), for: .touchUpInside)
        trackerButton.setTitle(NSLocalizedString("newTracker.trackerButton.title", comment: "Title for tracker button"), for: .normal)
        trackerButton.setTitleColor(.whiteYP, for: .normal)
        trackerButton.backgroundColor = .blackYP
        trackerButton.layer.cornerRadius = 16
        
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
        eventButton.setTitle(NSLocalizedString("newTracker.eventButton.title", comment: "Title for event button"), for: .normal)
        eventButton.setTitleColor(.whiteYP, for: .normal)
        eventButton.backgroundColor = .blackYP
        eventButton.layer.cornerRadius = 16
    }
    
    private func setupLayout() {
        view.addSubview(trackerButton)
        view.addSubview(eventButton)
        view.addSubview(topLabel)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(27)
            make.centerX.equalToSuperview()
        }
        
        trackerButton.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(60)
        }
        
        eventButton.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(trackerButton)
            make.top.equalTo(trackerButton.snp.bottom).offset(16)
        }
    }
    
    @objc private func trackerButtonTapped(sender: Any) {
        let vc = TrackerSetupViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func eventButtonTapped() {
        let vc = TrackerSetupViewController(isTracker: false)
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension NewTrackerViewController: TrackerSetupViewControllerDelegate {
    func dismiss() {
        delegate?.dismiss()
    }
}

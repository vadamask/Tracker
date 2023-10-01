//
//  ForkViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import SnapKit
import UIKit

final class NewTrackerViewController: UIViewController {
    
    private let topLabel = UILabel(text: "Создание трекера", textColor: .blackYP, font: .systemFont(ofSize: 16, weight: .medium))
    private let trackerButton = UIButton(title: "Привычка")
    private let eventButton = UIButton(title: "Нерегулярное событие")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        trackerButton.addTarget(self, action: #selector(trackerButtonTapped), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
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
        present(vc, animated: true)
    }
    
    @objc private func eventButtonTapped() {
        let vc = TrackerSetupViewController(isTracker: false)
        present(vc, animated: true)
    }
}

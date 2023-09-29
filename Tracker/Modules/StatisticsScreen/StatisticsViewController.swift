//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import SnapKit
import UIKit

final class StatisticsViewController: UIViewController {
    
    private let placeholder = UIImageView(image: UIImage(named: "empty statistics"))
    private let label = UILabel(text: "Анализировать пока нечего", textColor: .blackYP, font: .systemFont(ofSize: 12, weight: .medium))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        navigationItem.title = "Статистика"
        label.textAlignment = .center
    }
    
    private func setupLayout() {
        view.addSubview(placeholder)
        view.addSubview(label)
        
        placeholder.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(placeholder.snp.bottom).offset(8)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
    }
}

//
//  StatisticView.swift
//  Tracker
//
//  Created by Вадим Шишков on 13.10.2023.
//

import SnapKit
import UIKit

final class StatisticView: UIView {
    
    private let countLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let stackView = UIStackView()
    private let colors = Colors.shared
    private let gradient = CAGradientLayer()
    private let shape = CAShapeLayer()
    
    init(text: String) {
        super.init(frame: .zero)
        descriptionLabel.text = text
        setupViews()
        setupLayout()
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeText(_ text: String) {
        countLabel.text = text
    }
    
    private func setupViews() {
 
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        countLabel.font = .systemFont(ofSize: 34, weight: .bold)
        countLabel.textColor = colors.blackDynamicYP
        countLabel.text = "0"
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .medium)
        descriptionLabel.textColor = colors.blackDynamicYP
        
    }
    
    private func setupLayout() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.equalTo(12)
            make.trailing.bottom.equalTo(-12)
        }
    }
    
    func setupGradient() {
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.colors = [
            UIColor(red: 0, green: 0.48, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.27, green: 0.9, blue: 0.62, alpha: 1).cgColor,
            UIColor(red: 0.99, green: 0.3, blue: 0.29, alpha: 1).cgColor
        ]
        
        shape.lineWidth = 1
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.black.cgColor
        gradient.mask = shape
        
        layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        gradient.frame = self.bounds
        shape.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 1, dy: 1), cornerRadius: 16).cgPath
    }
    
    
}

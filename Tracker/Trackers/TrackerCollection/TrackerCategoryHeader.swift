//
//  TrackerCategoryHeader.swift
//  Tracker
//
//  Created by Вадим Шишков on 01.09.2023.
//

import UIKit

final class TrackerCategoryHeader: UICollectionReusableView {
    static let identifier = "header"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blackYP
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        label.text = title
    }
}

//
//  TrackerSetupSupView.swift
//  Tracker
//
//  Created by Вадим Шишков on 07.09.2023.
//

import UIKit

final class TrackerSetupSupView: UICollectionReusableView {
    static let identifier = "header"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with section: Int) {
        label.text = section == 0 ? "Emoji" : "Цвет"
    }
}

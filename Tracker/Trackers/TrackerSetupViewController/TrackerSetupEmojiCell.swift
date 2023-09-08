//
//  TrackerSetupCollectionCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 07.09.2023.
//

import UIKit

final class TrackerSetupEmojiCell: UICollectionViewCell {
    static let identifier = "EmojiCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with emoji: String) {
        label.text = emoji
    }
}

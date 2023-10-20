//
//  TrackerSetupCollectionCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 07.09.2023.
//

import SnapKit
import UIKit

final class EmojiCell: UICollectionViewCell {
    
    static let identifier = "EmojiCell"
    private let label = UILabel()
    
    func configure(with emoji: String) {
        label.text = emoji
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        layer.cornerRadius = 16
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

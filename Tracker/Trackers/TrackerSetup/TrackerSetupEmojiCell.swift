//
//  TrackerSetupCollectionCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 07.09.2023.
//

import SnapKit
import UIKit

final class TrackerSetupEmojiCell: UICollectionViewCell {
    
    static let identifier = "EmojiCell"
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with emoji: String) {
        label.text = emoji
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        layer.cornerRadius = 16
    }
}

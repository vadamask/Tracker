//
//  TrackerSetupColorCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 07.09.2023.
//

import SnapKit
import UIKit

final class TrackerSetupColorCell: UICollectionViewCell {
    
    static let identifier = "ColorCell"
    private let colorView = UIView()
    private let background = UIView()
    
    func configure(with index: Int) {
        colorView.backgroundColor = UIColor(named: "Color selection \(index)")
        colorView.layer.cornerRadius = 8
        
        background.layer.borderColor = UIColor(named: "Color selection \(index)")?.cgColor
        background.layer.opacity = 0.3
        background.layer.borderWidth = 3
        background.layer.cornerRadius = 8
        background.isHidden = true
        
        contentView.addSubview(background)
        contentView.addSubview(colorView)
        
        background.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
        colorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
    }
    
    func itemDidSelect(_ isSelect: Bool) {
        background.isHidden = isSelect ? false : true
    }
}

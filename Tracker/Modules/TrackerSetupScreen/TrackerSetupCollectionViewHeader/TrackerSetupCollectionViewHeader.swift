//
//  TrackerSetupSupView.swift
//  Tracker
//
//  Created by Вадим Шишков on 07.09.2023.
//

import SnapKit
import UIKit

final class TrackerSetupCollectionViewHeader: UICollectionReusableView {
    
    static let identifier = "header"
    private let label = UILabel()

    func configure(with section: Int) {
        label.text = section == 0 ?
        NSLocalizedString("setupTracker.emoji.header", comment: "Emoji header") :
        NSLocalizedString("setupTracker.color.header", comment: "Color header")
        
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.bottom.equalTo(-24)
        }
    }
}

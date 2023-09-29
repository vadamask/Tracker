//
//  TrackerSetupSupView.swift
//  Tracker
//
//  Created by Вадим Шишков on 07.09.2023.
//

import SnapKit
import UIKit

final class TrackerSetupSupView: UICollectionReusableView {
    
    static let identifier = "header"
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.bottom.equalTo(-24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with section: Int) {
        label.text = section == 0 ? "Emoji" : "Цвет"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
    }
}

//
//  TrackerCategoryHeader.swift
//  Tracker
//
//  Created by Вадим Шишков on 01.09.2023.
//

import SnapKit
import UIKit

final class TrackerCollectionViewHeader: UICollectionReusableView {
    
    static let identifier = "header"
    private let label = UILabel()
    private let colors = Colors.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        label.text = title
        label.textColor = colors.blackDynamicYP
        label.font = .systemFont(ofSize: 19, weight: .bold)
    }
}

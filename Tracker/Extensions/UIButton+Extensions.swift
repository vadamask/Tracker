//
//  UIButton+Extensions.swift
//  Tracker
//
//  Created by Вадим Шишков on 29.08.2023.
//

import UIKit

extension UIButton {
    convenience init(title: String, textColor: UIColor = .whiteYP, backgroundColor: UIColor = .blackYP) {
        self.init(type: .system)
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        layer.cornerRadius = 16
    }
}

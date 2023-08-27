//
//  UILabel+Extensions.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import UIKit

extension UILabel {
    
    convenience init(title: String) {
        self.init()
        text = title
        textColor = .blackYP
        font = UIFont.systemFont(ofSize: 16, weight: .medium)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

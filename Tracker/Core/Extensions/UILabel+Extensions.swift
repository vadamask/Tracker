//
//  UILabel+Extensions.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, textColor: UIColor, font: UIFont) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        translatesAutoresizingMaskIntoConstraints = false
    }
}

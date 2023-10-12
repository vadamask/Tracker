//
//  Colors.swift
//  Tracker
//
//  Created by Вадим Шишков on 12.10.2023.
//

import UIKit

final class Colors {
    
    static let shared = Colors()
    private init() {}
    
    let blackStaticYP = UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 1)
    let blackStaticYP30 = UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 0.3)
    let whiteStaticYP = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    let blueStaticYP = UIColor(red: 0.22, green: 0.45, blue: 0.91, alpha: 1)
    let grayStaticYP = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1)
    let redStaticYP = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1)
    let lightGrayStaticYP = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 1)
    
    let blackDynamicYP = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .light {
            return UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 1)
        } else {
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    let whiteDynamicYP = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .light {
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            return UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 1)
        }
    }
    
    let backgroundDynamicYP = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .light {
            return UIColor(red: 0.9, green: 0.91, blue: 0.92, alpha: 0.3)
        } else {
            return UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 0.85)
        }
    }
}

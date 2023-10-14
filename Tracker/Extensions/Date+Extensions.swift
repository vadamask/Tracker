//
//  Date+Extensions.swift
//  Tracker
//
//  Created by Вадим Шишков on 14.10.2023.
//

import Foundation

extension Date {
    var weekday: String {
        var weekday = Calendar(identifier: .gregorian).component(.weekday, from: self)
        weekday = weekday == 1 ? 6 : (weekday - 2)
        return String(weekday)
    }
}

//
//  ScheduleCellViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.09.2023.
//

import Foundation

final class ScheduleCellViewModel {
    var isOn: Bool
    let day: WeekDay
    
    init(day: WeekDay, isOn: Bool) {
        self.isOn = isOn
        self.day = day
    }
    
    func switchTapped(_ isOn: Bool) {
        self.isOn = isOn
    }
}

//
//  WeekDay.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.09.2023.
//

import Foundation

enum WeekDay: Int {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var fullName: String {
        switch self {
        case .monday:
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        default:
            return ""
        }
    }
    
    static func shortName(for day: Int) -> String {
        switch day {
        case 0:
            return "Пн"
        case 1:
            return "Вт"
        case 2:
            return "Ср"
        case 3:
            return "Чт"
        case 4:
            return "Пт"
        case 5:
            return "Сб"
        case 6:
            return "Вс"
        default:
            return ""
        }
    }
}

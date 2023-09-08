//
//  Tracker.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import Foundation

struct Tracker {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: Set<WeekDay>
}

enum WeekDay: Int {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    static func fullName(for day: Int) -> String {
        switch day {
        case 0:
            return "Понедельник"
        case 1:
            return "Вторник"
        case 2:
            return "Среда"
        case 3:
            return "Четверг"
        case 4:
            return "Пятница"
        case 5:
            return "Суббота"
        case 6:
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

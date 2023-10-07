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
            return NSLocalizedString("mondayFull", comment: "")
        case .tuesday:
            return NSLocalizedString("tuesdayFull", comment: "")
        case .wednesday:
            return NSLocalizedString("wednesdayFull", comment: "")
        case .thursday:
            return NSLocalizedString("thursdayFull", comment: "")
        case .friday:
            return NSLocalizedString("fridayFull", comment: "")
        case .saturday:
            return NSLocalizedString("saturdayFull", comment: "")
        case .sunday:
            return NSLocalizedString("sundayFull", comment: "")
        }
    }
    
    var shortName: String {
        switch self {
        case .monday:
            return NSLocalizedString("mondayShort", comment: "")
        case .tuesday:
            return NSLocalizedString("tuesdayShort", comment: "")
        case .wednesday:
            return NSLocalizedString("wednesdayShort", comment: "")
        case .thursday:
            return NSLocalizedString("thursdayShort", comment: "")
        case .friday:
            return NSLocalizedString("fridayShort", comment: "")
        case .saturday:
            return NSLocalizedString("saturdayShort", comment: "")
        case .sunday:
            return NSLocalizedString("sundayShort", comment: "")
        }
    }
}

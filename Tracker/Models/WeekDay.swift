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
            return L10n.Localizable.mondayFull
        case .tuesday:
            return L10n.Localizable.tuesdayFull
        case .wednesday:
            return L10n.Localizable.wednesdayFull
        case .thursday:
            return L10n.Localizable.thursdayFull
        case .friday:
            return L10n.Localizable.fridayFull
        case .saturday:
            return L10n.Localizable.saturdayFull
        case .sunday:
            return L10n.Localizable.sundayFull
        }
    }
    
    var shortName: String {
        switch self {
        case .monday:
            return L10n.Localizable.mondayShort
        case .tuesday:
            return L10n.Localizable.tuesdayShort
        case .wednesday:
            return L10n.Localizable.wednesdayShort
        case .thursday:
            return L10n.Localizable.thursdayShort
        case .friday:
            return L10n.Localizable.fridayShort
        case .saturday:
            return L10n.Localizable.saturdayShort
        case .sunday:
            return L10n.Localizable.sundayShort
        }
    }
}

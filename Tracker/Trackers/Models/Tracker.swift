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
    let schedule: [WeekDay]
}

struct WeekDay {
    let fullName: String
    let shortName: String
    let isOn: Bool
}

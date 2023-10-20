//
//  Tracker.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import Foundation

struct Tracker: Comparable {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: Set<WeekDay>
    let isPinned: Bool
    
    static func < (lhs: Tracker, rhs: Tracker) -> Bool {
        lhs.name < rhs.name
    }
}

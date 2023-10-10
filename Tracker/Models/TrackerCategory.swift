//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import Foundation

struct TrackerCategory: Comparable {
    static func < (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.title < rhs.title
    }
    
    let title: String
    let trackers: [Tracker]
}

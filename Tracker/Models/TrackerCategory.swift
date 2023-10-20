//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import Foundation

struct TrackerCategory: Comparable {
    let title: String
    let trackers: [Tracker]
    
    static func < (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.title < rhs.title
    }
}

//
//  Notification.Name+Extensions.swift
//  Tracker
//
//  Created by Вадим Шишков on 19.10.2023.
//

import Foundation

extension Notification.Name {
    static let trackersChanged = Notification.Name("Trackers changed")
    static let categoryChanged = Notification.Name("Category changed")
    static let categoryAdded = Notification.Name("Category added")
    static let categoryDeleted = Notification.Name("Category deleted")
    static let recordsChanged = Notification.Name("Records changed")
}

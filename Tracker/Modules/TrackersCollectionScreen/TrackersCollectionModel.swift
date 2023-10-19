//
//  TrackersCollectionModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 01.10.2023.
//

import Foundation

final class TrackersCollectionModel {
    
    private let trackerStore = TrackerStore()
    private let recordStore = TrackerRecordStore()
    
    private var currentDate = Date()
    
    var stringDate: String {
        dateFormatter.string(from: currentDate)
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        return formatter
    }()
    
    func fetchTracker(with id: UUID) throws -> (TrackerCategory, Int)? {
        try trackerStore.fetchTracker(with: id.uuidString)
    }
    
    func fetchTrackersAtCurrentDate() throws -> [TrackerCategory] {
        try trackerStore.fetchCategoriesWithTrackers(at: currentDate.weekday)
    }
    
    func fetchTrackers(at date: Date) throws -> [TrackerCategory] {
        currentDate = date
        return try fetchTrackersAtCurrentDate()
    }
    
    func fetchCompletedTrackers() throws -> [TrackerCategory] {
        try trackerStore.fetchCompletedTrackers(today: stringDate)
    }
    
    func fetchIncompleteTrackers() throws -> [TrackerCategory] {
        let weekday = currentDate.weekday
        return try trackerStore.fetchIncompleteTrackers(at: weekday, stringDate)
    }
    
    func detailsFor(_ trackerID: UUID) throws -> Details {
        return try recordStore.detailsFor(trackerID, at: stringDate)
    }
    
    func addRecord(with recordID: UUID, for trackerID: UUID) throws {
        if currentDate < Date() {
            
            try recordStore.addRecord(
                TrackerRecord(id: recordID, date: stringDate),
                for: trackerID
            )
        }
    }
    
    func deleteRecord(with recordID: UUID) throws {
        if currentDate < Date() {
            try recordStore.deleteRecord(with: recordID)
        }
    }
    
    func deleteTracker(with id: UUID) throws {
        try trackerStore.deleteTracker(with: id.uuidString)
    }
    
    func pinTracker(with id: UUID, isPinned: Bool) throws {
        try trackerStore.pinTracker(with: id.uuidString, isPinned: isPinned)
    }
}



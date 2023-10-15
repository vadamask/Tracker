//
//  TrackersCollectionModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 01.10.2023.
//

import Foundation

final class TrackersCollectionModel {
    
    let trackerStore = TrackerStore()
    let recordStore = TrackerRecordStore()
    
    private var currentDate = Date()
    
    var stringDate: String {
        dateFormatter.string(from: currentDate)
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        return formatter
    }()
    
    func fetchTracker(with id: UUID) -> (TrackerCategory, Int)? {
        do {
            return try trackerStore.fetchTracker(with: id.uuidString)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchTrackersAtCurrentDate() -> [TrackerCategory] {
        do {
            return try trackerStore.fetchCategoriesWithTrackers(at: currentDate.weekday)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchTrackers(at date: Date) -> [TrackerCategory] {
        currentDate = date
        return fetchTrackersAtCurrentDate()
    }
    
    func fetchCompletedTrackers() -> [TrackerCategory] {
        do {
            return try trackerStore.fetchCompletedTrackers(today: stringDate)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchIncompleteTrackers() -> [TrackerCategory] {
        let weekday = currentDate.weekday
        do {
            return try trackerStore.fetchIncompleteTrackers(at: weekday, stringDate)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func detailsFor(_ tracker: Tracker) -> (isDone: Bool, completedDays: Int) {
        do {
            return try recordStore.detailsFor(tracker.id, at: stringDate)
        } catch {
            print(error.localizedDescription)
            return (false, 0)
        }
    }
    
    func addRecord(with id: UUID) {
        if currentDate < Date() {
            do {
                try recordStore.addRecord(TrackerRecord(id: id, date: stringDate))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteRecord(with id: UUID) {
        do {
            try recordStore.deleteRecord(with: id, at: stringDate)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteTracker(with id: UUID) {
        do {
            try trackerStore.deleteTracker(with: id.uuidString)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func pinTracker(with id: UUID, isPinned: Bool) {
        do {
            try trackerStore.pinTracker(with: id.uuidString, isPinned: isPinned)
        } catch {
            print(error.localizedDescription)
        }
    }
}



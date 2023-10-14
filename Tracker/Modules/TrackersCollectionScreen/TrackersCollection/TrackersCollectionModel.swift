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
        do {
            return try trackerStore.fetchCategoriesWithTrackers(at: currentDate.weekday)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchCompletedTrackers() -> [TrackerCategory] {
        let weekday = currentDate.weekday
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
            return try recordStore.detailsFor(tracker.uuid, at: stringDate)
        } catch {
            print(error.localizedDescription)
            return (false, 0)
        }
    }
    
    func willAddRecord(with uuid: UUID) -> Bool {
        if currentDate < Date() {
            do {
                try recordStore.addRecord(TrackerRecord(uuid: uuid, date: stringDate))
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        return false
    }
    
    func willDeleteRecord(with uuid: UUID) -> Bool {
        do {
            try recordStore.removeRecord(with: uuid, at: stringDate)
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
    
    func deleteTracker(with uuid: UUID) {
        do {
            try trackerStore.deleteTracker(with: uuid.uuidString)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func pinTracker(with uuid: UUID, isPinned: Bool) {
        do {
            try trackerStore.changeCategory(for: uuid.uuidString, isPinned: isPinned)
        } catch {
            print(error.localizedDescription)
        }
    }
}



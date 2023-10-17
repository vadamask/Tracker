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
    
    func detailsFor(_ trackerID: UUID) -> Details {
        do {
            return try recordStore.detailsFor(trackerID, at: stringDate)
        } catch {
            print(error.localizedDescription)
            return Details(isDone: false, completedDays: 0, recordID: UUID())
        }
    }
    
    func addRecord(with recordID: UUID, for trackerID: UUID) {
        if currentDate < Date() {
            do {
                try recordStore.addRecord(
                    TrackerRecord(id: recordID, date: stringDate),
                    for: trackerID
                )
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteRecord(with recordID: UUID) {
        do {
            try recordStore.deleteRecord(with: recordID)
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



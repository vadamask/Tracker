//
//  TrackersCollectionViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 01.10.2023.
//

import Foundation

final class TrackersCollectionViewModel {

    @Observable var categories: [TrackerCategory] = []
    @Observable var searchIsEmpty = false
    @Observable var filter: Filter = .all
    @Observable var error: Error?

    private var model = TrackersCollectionModel()
    
    var stringSelectedDate: String {
        model.stringDate
    }
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchTrackersAtCurrentDate),
            name: Notification.Name.trackersChanged,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchTrackersAtCurrentDate),
            name: Notification.Name.categoryDeleted,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchTrackersAtCurrentDate),
            name: Notification.Name.categoryChanged,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchTrackersAtCurrentDate),
            name: Notification.Name.recordsChanged,
            object: nil)
    }
    
    @objc func fetchTrackersAtCurrentDate() {
        switch filter {
        case .all:
            do {
                categories = try model.fetchTrackersAtCurrentDate()
            } catch {
                self.error = error
            }
        case .today:
            do {
                categories = try model.fetchTrackersAtCurrentDate()
            } catch {
                self.error = error
            }
        case .completed:
            
            fetchCompletedTrackers()
        case .incomplete:
            fetchIncompleteTrackers()
        }
    }
    
    func fetchTracker(at indexPath: IndexPath) -> (TrackerCategory, Int)? {
        let id = categories[indexPath.section].trackers[indexPath.row].id
        do {
            return try model.fetchTracker(with: id)
        } catch {
            self.error = error
            return nil
        }
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        let id = categories[indexPath.section].trackers[indexPath.row].id
        do {
            try model.deleteTracker(with: id)
        } catch {
            self.error = error
        }
    }
    
    func pinTracker(at indexPath: IndexPath) {
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        do {
            try model.pinTracker(with: tracker.id, isPinned: tracker.isPinned)
        } catch {
            self.error = error
        }
    }
    
    func detailsFor(_ trackerID: UUID) -> Details? {
        do {
            return try model.detailsFor(trackerID)
        } catch {
            self.error = error
            return nil
        }
    }
    
    func dateDidChanged(_ date: Date) {
        do {
            categories = try model.fetchTrackers(at: date)
            filter = .all
        } catch {
            self.error = error
        }
        
    }
    
    func fetchCompletedTrackers() {
        do {
            categories = try model.fetchCompletedTrackers()
            if categories.isEmpty {
                searchIsEmpty = true
            }
        } catch {
            self.error = error
        }
    }
    
    func fetchIncompleteTrackers() {
        do {
            categories = try model.fetchIncompleteTrackers()
            if categories.isEmpty {
                searchIsEmpty = true
            }
        } catch {
            self.error = error
        }
    }
    
    func searchFieldDidChanged(_ searchText: String) {
        if searchText.isEmpty {
            do {
                categories = try model.fetchTrackersAtCurrentDate()
            } catch {
                self.error = error
            }
        } else {
            do {
                let categories = try model.fetchTrackersAtCurrentDate()
                let filteredCategories = categories.map {
                    TrackerCategory(
                        title: $0.title,
                        trackers: $0.trackers.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                    )
                }.filter { !$0.trackers.isEmpty }
                self.categories = filteredCategories
            } catch {
                self.error = error
            }
        }
        searchIsEmpty = categories.isEmpty ? true : false
    }
    
    func addRecord(with recordID: UUID, for trackerID: UUID) {
        do {
            try model.addRecord(with: recordID, for: trackerID)
        } catch {
            self.error = error
        }
    }
    
    func deleteRecord(with recordID: UUID) {
        do {
            try model.deleteRecord(with: recordID)
        } catch {
            self.error = error
        }
    }
    
    func didSelectedFilter(_ filter: Filter) {
        self.filter = filter
    }
    
    func addMock() {
        categories = [TrackerCategory(
            title: "Test", trackers: [
                Tracker(
                    id: UUID(),
                    name: "Test",
                    color: "Color selection 0",
                    emoji: "😂",
                    schedule: Set([.monday]),
                    isPinned: true
                ),
                Tracker(
                    id: UUID(),
                    name: "Test2",
                    color: "Color selection 1",
                    emoji: "🤪",
                    schedule: Set([.monday]),
                    isPinned: false
                )
            ]
        )]
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
}

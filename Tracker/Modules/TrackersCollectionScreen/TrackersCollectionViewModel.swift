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
            categories = model.fetchTrackersAtCurrentDate()
        case .today:
            categories = model.fetchTrackersAtCurrentDate()
        case .completed:
            fetchCompletedTrackers()
        case .incomplete:
            fetchIncompleteTrackers()
        }
    }
    
    func fetchTracker(at indexPath: IndexPath) -> (TrackerCategory, Int)? {
        let id = categories[indexPath.section].trackers[indexPath.row].id
        return model.fetchTracker(with: id)
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        let id = categories[indexPath.section].trackers[indexPath.row].id
        model.deleteTracker(with: id)
    }
    
    func pinTracker(at indexPath: IndexPath) {
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        model.pinTracker(with: tracker.id, isPinned: tracker.isPinned)
    }
    
    func detailsFor(_ trackerID: UUID) -> Details {
        return model.detailsFor(trackerID)
    }
    
    func dateDidChanged(_ date: Date) {
        categories = model.fetchTrackers(at: date)
        filter = .all
    }
    
    func fetchCompletedTrackers() {
        categories = model.fetchCompletedTrackers()
        if categories.isEmpty {
            searchIsEmpty = true
        }
    }
    
    func fetchIncompleteTrackers() {
        categories = model.fetchIncompleteTrackers()
        if categories.isEmpty {
            searchIsEmpty = true
        }
    }
    
    func searchFieldDidChanged(_ searchText: String) {
        if searchText.isEmpty {
            categories = model.fetchTrackersAtCurrentDate()
        } else {
            let categories = model.fetchTrackersAtCurrentDate()
            let filteredCategories = categories.map {
                TrackerCategory(
                    title: $0.title,
                    trackers: $0.trackers.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                )
            }.filter { !$0.trackers.isEmpty }
            self.categories = filteredCategories
        }
        searchIsEmpty = categories.isEmpty ? true : false
    }
    
    func addRecord(with recordID: UUID, for trackerID: UUID) {
        model.addRecord(with: recordID, for: trackerID)
    }
    
    func deleteRecord(with recordID: UUID) {
        model.deleteRecord(with: recordID)
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

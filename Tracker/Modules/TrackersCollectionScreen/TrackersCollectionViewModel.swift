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

    private var model = TrackersCollectionModel()
    
    var stringSelectedDate: String {
        model.stringDate
    }
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchTrackersAtCurrentDate),
            name: Notification.Name(rawValue: "Trackers changed"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchTrackersAtCurrentDate),
            name: Notification.Name(rawValue: "Category deleted"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchTrackersAtCurrentDate),
            name: Notification.Name(rawValue: "Category changed"),
            object: nil)
    }
    
    @objc func fetchTrackersAtCurrentDate() {
        categories = model.fetchTrackersAtCurrentDate()
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
    
    func detailsFor(_ tracker: Tracker) -> (isDone: Bool, completedDays: Int) {
        return model.detailsFor(tracker)
    }
    
    func dateDidChanged(_ date: Date) {
        categories = model.fetchTrackers(at: date)
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
                    trackers: $0.trackers.filter { $0.name.lowercased().hasPrefix(searchText.lowercased()) }
                )
            }.filter { !$0.trackers.isEmpty }
            self.categories = filteredCategories
        }
        searchIsEmpty = categories.isEmpty ? true : false
    }
    
    func addRecord(with id: UUID) {
        model.addRecord(with: id)
    }
    
    func deleteRecord(with id: UUID) {
        model.deleteRecord(with: id)
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
}

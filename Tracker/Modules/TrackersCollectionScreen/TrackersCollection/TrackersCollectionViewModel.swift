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
    private var indexes: [IndexPath]?
    
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
        var categories = model.fetchTrackersAtCurrentDate()
        if let index = categories.firstIndex(where: {$0.title == L10n.Localizable.CollectionScreen.pinHeader}) {
            categories.swapAt(index, 0)
            self.categories = categories
        } else {
            self.categories = categories
        }
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        let uuid = categories[indexPath.section].trackers[indexPath.row].uuid
        model.deleteTracker(with: uuid)
    }
    
    func pinTracker(at indexPath: IndexPath, isPinned: Bool) {
        model.pinTracker(with: categories[indexPath.section].trackers[indexPath.row].uuid, isPinned: isPinned)
    }
    
    func detailsFor(_ tracker: Tracker) -> (isDone: Bool, completedDays: Int) {
        return model.detailsFor(tracker)
    }
    
    func dateDidChanged(_ date: Date) {
        categories = model.fetchTrackers(at: date)
    }
    
    func fetchCompletedTrackers() {
        categories = model.fetchCompletedTrackers()
    }
    
    func fetchIncompleteTrackers() {
        categories = model.fetchIncompleteTrackers()
    }
    
    func searchFieldDidChanged(_ searchText: String) {
        let filteredCategories = categories.map {
            TrackerCategory(
                title: $0.title,
                trackers: $0.trackers.filter { $0.name.lowercased().hasPrefix(searchText.lowercased()) }
            )
        }.filter { !$0.trackers.isEmpty }
        categories = filteredCategories
        searchIsEmpty = filteredCategories.isEmpty ? true : false
    }
    
    func willAddRecord(with uuid: UUID) -> Bool {
        model.willAddRecord(with: uuid)
    }
    
    func willDeleteRecord(with uuid: UUID) -> Bool {
        model.willDeleteRecord(with: uuid)
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
}

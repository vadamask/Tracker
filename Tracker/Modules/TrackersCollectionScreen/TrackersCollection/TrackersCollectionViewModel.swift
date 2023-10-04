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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateView),
                                               name: Notification.Name(rawValue: "trackers changed"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateView),
                                               name: Notification.Name(rawValue: "Category deleted"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateView),
                                               name: Notification.Name(rawValue: "Category changed"),
                                               object: nil)
    }
    
    @objc private func updateView() {
        fetchObjectsAtCurrentDate()
    }
    
    func fetchObjectsAtCurrentDate() {
        categories = model.fetchObjectsAtCurrentDate()
    }
    
    func detailsFor(_ tracker: Tracker) -> (isDone: Bool, completedDays: Int) {
        return model.detailsFor(tracker)
    }
    
    func dateDidChanged(_ date: Date) {
        categories = model.fetchObjects(at: date)
    }
    
    func searchFieldDidChanged(_ searchText: String) {
        let filteredCategories = categories.map {
            TrackerCategory(title: $0.title, trackers: $0.trackers.filter { $0.name.hasPrefix(searchText) })
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

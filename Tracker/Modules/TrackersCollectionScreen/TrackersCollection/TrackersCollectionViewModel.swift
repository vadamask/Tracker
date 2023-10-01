//
//  TrackersCollectionViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 01.10.2023.
//

import Foundation

final class TrackersCollectionViewModel {

    @Observable var stateChanged = false
    @Observable var emptyState = false
    @Observable var emptySearch = false
    @Observable var updatedState: TrackerStoreUpdate?
    
    private var model: TrackersCollectionModel
    
    init() {
        model = TrackersCollectionModel()
        model.delegate = self
    }
    
    var stringSelectedDate: String {
        model.stringSelectedDate
    }
    
    func fetchObjectsAtCurrentDate() {
        model.fetchObjectsAtCurrentDate()
        emptyState = model.emptyState
    }
    
    func dateDidChanged(_ date: Date) {
        model.fetchObjects(at: date)
        emptyState = model.emptyState
    }
    
    func searchFieldDidChanged(_ searchText: String) {
        model.searchObjects(with: searchText)
        emptySearch = model.emptyState
    }
    
    func willAddRecord(with uuid: UUID) -> Bool {
        model.willAddRecord(with: uuid)
    }
    
    func willDeleteRecord(with uuid: UUID) -> Bool {
        model.willDeleteRecord(with: uuid)
    }
}

// MARK: - CollectionViewDataSource

extension TrackersCollectionViewModel {
    
    var numberOfSections: Int {
        model.numberOfSections
    }
    
    func numberOfItems(in section: Int) -> Int {
        model.numberOfItems(in: section)
    }
    
    func cellForItem(at indexPath: IndexPath) -> Tracker {
        model.cellForItem(at: indexPath)
    }
    
    func detailsForCell(_ indexPath: IndexPath, at date: String) -> (isDone: Bool, completedDays: Int) {
        model.detailsForCell(indexPath, at: date)
    }
    
    func titleForSection(at indexPath: IndexPath) -> String {
        model.titleForSection(at: indexPath)
    }
}

extension TrackersCollectionViewModel: TrackersCollectionModelDelegate {
    
    func didUpdate(_ trackerStoreUpdate: TrackerStoreUpdate) {
        self.updatedState = trackerStoreUpdate
        emptyState = model.emptyState
    }
    
    func didFetchedObjects() {
        stateChanged = true
    }
}

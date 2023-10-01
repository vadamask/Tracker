//
//  TrackersCollectionModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 01.10.2023.
//

import Foundation

protocol TrackersCollectionModelDelegate: AnyObject {
    func didUpdate(_ trackerStoreUpdate: TrackerStoreUpdate)
    func didFetchedObjects()
}

final class TrackersCollectionModel {
    
    let trackerStore = TrackerStore()
    let recordStore = TrackerRecordStore()
    weak var delegate: TrackersCollectionModelDelegate?
    
    private var currentDate = Date()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        return formatter
    }()
    
    init() {
        trackerStore.delegate = self
    }
    
    var emptyState: Bool {
        trackerStore.numberOfSections == 0
    }
    
    var stringSelectedDate: String {
        dateFormatter.string(from: currentDate) 
    }
    
    func searchObjects(with searchText: String) {
        do {
            try trackerStore.searchTrackers(with: searchText, at: currentDate)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - DatePicker

extension TrackersCollectionModel {
    
    func fetchObjects(at date: Date) {
        currentDate = date
        do {
            return try trackerStore.fetchObjects(at: date)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchObjectsAtCurrentDate() {
        do {
            return try trackerStore.fetchObjects(at: currentDate)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - CollectionViewDataSource

extension TrackersCollectionModel {
    
    var numberOfSections: Int {
        trackerStore.numberOfSections
    }
    
    func numberOfItems(in section: Int) -> Int {
        trackerStore.numberOfItems(in: section)
    }
    
    func cellForItem(at indexPath: IndexPath) -> Tracker {
        trackerStore.cellForItem(at: indexPath)
    }
    
    func detailsForCell(_ indexPath: IndexPath, at date: String) -> (isDone: Bool, completedDays: Int) {
        trackerStore.detailsForCell(indexPath, at: date)
    }
    
    func titleForSection(at indexPath: IndexPath) -> String {
        trackerStore.titleForSection(at: indexPath)
    }
    
    func willAddRecord(with uuid: UUID) -> Bool {
        if currentDate < Date() {
            do {
                try recordStore.addRecord(TrackerRecord(uuid: uuid, date: dateFormatter.string(from: currentDate)))
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
            try recordStore.removeRecord(with: uuid, at: dateFormatter.string(from: currentDate))
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
}

// MARK: - TrackerStoreDelegate

extension TrackersCollectionModel: TrackerStoreDelegate {
    
    func didUpdate(_ trackerStoreUpdate: TrackerStoreUpdate) {
        delegate?.didUpdate(trackerStoreUpdate)
    }
    
    func didFetchedObjects() {
        delegate?.didFetchedObjects()
    }
}


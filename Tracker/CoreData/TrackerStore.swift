//
//  TrackerStore.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.09.2023.
//

import CoreData
import UIKit

struct TrackerStoreUpdate {
    let insertedItems: [IndexPath]
    let deletedItems: [IndexPath]
    let insertedSections: IndexSet
    let deletedSections: IndexSet
}

protocol TrackerStoreDelegate: AnyObject {
    func didUpdate(_ trackerStoreUpdate: TrackerStoreUpdate)
    func didFetchedObjects()
}

final class TrackerStore: NSObject {
    
    weak var delegate: TrackerStoreDelegate?
    private let context: NSManagedObjectContext
    private var insertedItems: [IndexPath] = []
    private var deletedItems: [IndexPath] = []
    private var insertedSections: IndexSet = []
    private var deletedSections: IndexSet = []
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience override init() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Failed with context")
        }
        self.init(context: context)
        
        let request = TrackerCoreData.fetchRequest()
        let date = weekday(for: Date())
        request.sortDescriptors = [NSSortDescriptor(key: "category.title", ascending: true)]
        request.predicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(TrackerCoreData.schedule), date)
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(TrackerCoreData.category.title),
            cacheName: nil
        )
        controller.delegate = self
        try? controller.performFetch()
        fetchedResultsController = controller
    }
    
    func add(_ tracker: Tracker, with categoryTitle: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), categoryTitle)
        let categories = try context.fetch(request)
        guard !categories.isEmpty else { return }
        
        let object = TrackerCoreData(context: context)
        object.uuid = tracker.uuid.uuidString
        object.color = tracker.color
        object.emoji = tracker.emoji
        object.name = tracker.name
        object.schedule = tracker.schedule.map {String($0.rawValue)}.joined(separator: ",")
        object.category = categories[0]
        try context.save()
    }
    
    func numberOfSections() -> Int? {
        fetchedResultsController?.sections?.count
    }
    
    func titleForSection(at indexPath: IndexPath) -> String? {
        return fetchedResultsController?.sections?[indexPath.section].name
    }
    
    func numberOfItemsIn(_ section: Int) -> Int? {
        fetchedResultsController?.sections?[section].numberOfObjects
    }
    
    func cellForItem(at indexPath: IndexPath) -> Tracker? {
        if let object = fetchedResultsController?.object(at: indexPath) {
            return convertToTracker(object)
        } else {
            return nil
        }
    }
    
    func detailsForCell(_ indexPath: IndexPath, at date: String) -> (isDone: Bool, completedDays: Int) {
        if let object = fetchedResultsController?.object(at: indexPath),
           let records = object.records as? Set<TrackerRecordCoreData> {
            return (
                records.contains(where: { $0.date == date }),
                records.count
            )
        }
        return (false, 0)
    }
    
    func filterTrackers(at date: Date) {
        let weekday = weekday(for: date)
        let datePredicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(TrackerCoreData.schedule), weekday)
        fetchedResultsController?.fetchRequest.predicate = datePredicate
        do {
            try fetchedResultsController?.performFetch()
            delegate?.didFetchedObjects()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func searchTrackers(with prefix: String, at date: Date) {
        let weekday = weekday(for: date)
        let prefixPredicate = NSPredicate(format: "%K BEGINSWITH[c] %@", #keyPath(TrackerCoreData.name), prefix)
        let datePredicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(TrackerCoreData.schedule), weekday)
        fetchedResultsController?.fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [prefixPredicate, datePredicate])
        do {
            try fetchedResultsController?.performFetch()
            delegate?.didFetchedObjects()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func convertToTracker(_ object: TrackerCoreData) -> Tracker {
        guard
            let id = object.uuid,
            let name = object.name,
            let color = object.color,
            let emoji = object.emoji,
            let rawValues = object.schedule
        else { fatalError() }
        
        let schedule = rawValues.components(separatedBy: ",").compactMap { Int($0) }.compactMap { WeekDay(rawValue: $0)}
        return Tracker(
            uuid: UUID(uuidString: id) ?? UUID(),
            name: name,
            color: color,
            emoji: emoji,
            schedule: Set(schedule)
        )
    }
    
    private func weekday(for selectedDate: Date) -> String {
        var weekday = Calendar(identifier: .gregorian).component(.weekday, from: selectedDate)
        weekday = weekday == 1 ? 6 : (weekday - 2)
        return String(weekday)
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedItems.append(indexPath)
            }
        case .delete:
            if let indexPath = newIndexPath {
                deletedItems.append(indexPath)
            }
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            insertedSections.insert(sectionIndex)
        case .delete:
            deletedSections.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(TrackerStoreUpdate(
            insertedItems: insertedItems,
            deletedItems: deletedItems,
            insertedSections: insertedSections,
            deletedSections: deletedSections)
        )
        insertedItems.removeAll()
        deletedItems.removeAll()
        insertedSections.removeAll()
        deletedSections.removeAll()
    }
}

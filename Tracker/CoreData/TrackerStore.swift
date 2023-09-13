//
//  TrackerStore.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.09.2023.
//

import UIKit
import CoreData

struct TrackerStoreUpdate {
    let insertedIndexes: [IndexPath]
    let deletedIndexes: [IndexPath]
}

protocol TrackerStoreDelegate: AnyObject {
    func didUpdate(_ trackerStoreUpdate: TrackerStoreUpdate)
}

final class TrackerStore: NSObject {
    
    let context: NSManagedObjectContext
    weak var delegate: TrackerStoreDelegate?
    
    private var insertedIndexes: [IndexPath] = []
    private var deletedIndexes: [IndexPath] = []
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init(selectedDate: Date) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            self.init(context: context)
        } else {
            fatalError("Failed with context")
        }
        
        let request = TrackerCoreData.fetchRequest()
        let date = weekday(for: selectedDate)
        request.sortDescriptors = [NSSortDescriptor(key: "category.title", ascending: false)]
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
        
        let entity = TrackerCoreData(context: context)
        entity.uuid = tracker.uuid.uuidString
        entity.color = tracker.color
        entity.emoji = tracker.emoji
        entity.name = tracker.name
        entity.schedule = tracker.schedule.map {String($0.rawValue)}.joined(separator: ",")
        entity.category = categories[0]
        try context.save()
    }
    
    func numberOfSections() -> Int? {
        fetchedResultsController?.sections?.count
    }
    
    func numberOfItemsIn(_ section: Int) -> Int? {
        fetchedResultsController?.sections?[section].numberOfObjects
    }
    
    func cellForItem(at indexPath: IndexPath) -> Tracker? {
        if let entity = fetchedResultsController?.object(at: indexPath) {
            return convertToTracker(entity)
        } else {
            return nil
        }
    }
    
    func titleForSection(at indexPath: IndexPath) -> String? {
        return fetchedResultsController?.sections?[indexPath.section].name
    }
    
    func detailsFor(_ indexPath: IndexPath, at date: String) -> (isDone: Bool, completedDays: Int) {
        if let object = fetchedResultsController?.object(at: indexPath),
           let records = object.records as? Set<TrackerRecordCoreData> {
            return (
                records.contains(where: { $0.date == date }),
                records.count
            )
        }
        return (false, 0)
    }
    
    private func convertToTracker(_ entity: TrackerCoreData) -> Tracker {
        guard
            let id = entity.uuid,
            let name = entity.name,
            let color = entity.color,
            let emoji = entity.emoji,
            let rawValues = entity.schedule
        else { fatalError() }
        
        let schedule = rawValues.components(separatedBy: ",").compactMap { Int($0) }.compactMap { WeekDay(rawValue: $0)}
        
        return Tracker(uuid: UUID(uuidString: id) ?? UUID(), name: name, color: color, emoji: emoji, schedule: Set(schedule))
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
                insertedIndexes.append(indexPath)
            }
        case .delete:
            if let indexPath = newIndexPath {
                deletedIndexes.append(indexPath)
            }
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(TrackerStoreUpdate(insertedIndexes: insertedIndexes, deletedIndexes: deletedIndexes))
        insertedIndexes.removeAll()
        deletedIndexes.removeAll()
    }
}

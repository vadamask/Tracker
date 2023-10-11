//
//  TrackerStore.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.09.2023.
//

import CoreData
import UIKit

final class TrackerStore: NSObject {
    
    private let context: NSManagedObjectContext
    private var notification = Notification(name: Notification.Name("Trackers changed"))
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience override init() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Failed with context")
        }
        self.init(context: context)
    }
    
    func fetchCategoriesWithTrackers(at weekday: String) throws -> [TrackerCategory] {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(TrackerCoreData.schedule), weekday)
        
        let objects = try context.fetch(request)
        var dict: [String: [Tracker]] = [:]
        
        objects.forEach { object in
            let tracker = convertToTracker(object)
            if dict[object.category?.title ?? ""] != nil {
                dict[object.category?.title ?? ""]?.append(tracker)
            } else {
                dict.updateValue([tracker], forKey: object.category?.title ?? "")
            }
        }
            
        return dict
            .map { TrackerCategory(title: $0.key, trackers: $0.value.sorted(by: <)) }
            .sorted(by: <)
    }
    
    func addTracker(_ tracker: Tracker, with categoryTitle: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), categoryTitle)
        let categories = try context.fetch(request)
        guard !categories.isEmpty else { throw StoreError.categoriesIsEmpty }
        
        let object = TrackerCoreData(context: context)
        object.uuid = tracker.uuid.uuidString
        object.color = tracker.color
        object.emoji = tracker.emoji
        object.name = tracker.name
        object.schedule = tracker.schedule.map {String($0.rawValue)}.joined(separator: ",")
        object.category = categories[0]
        try context.save()
        NotificationCenter.default.post(notification)
    }
    
    func changeTracker(with model: TrackerCategory) throws {
        let trackerRequest = TrackerCoreData.fetchRequest()
        trackerRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.uuid),
            model.trackers[0].uuid.uuidString
        )
        let trackerObject = try context.fetch(trackerRequest).first
        
        let categoryRequest = TrackerCategoryCoreData.fetchRequest()
        categoryRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.title),
            model.title
        )
        let categoryObject = try context.fetch(categoryRequest).first
        
        trackerObject?.name = model.trackers[0].name
        trackerObject?.category = categoryObject
        trackerObject?.color = model.trackers[0].color
        trackerObject?.emoji = model.trackers[0].emoji
        trackerObject?.schedule = model.trackers[0].schedule.map {String($0.rawValue)}.joined(separator: ",")
        try context.save()
        NotificationCenter.default.post(notification)
    }
    
    func deleteTracker(with uuid: String) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@" , #keyPath(TrackerCoreData.uuid), uuid)
        let trackers = try context.fetch(request)
        context.delete(trackers[0])
        try context.save()
        NotificationCenter.default.post(notification)
    }
    
    func fetchCompletedTrackers(today: String) throws -> [TrackerCategory] {
        
        let recordsRequest = TrackerRecordCoreData.fetchRequest()
        recordsRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), today)
        let records = try context.fetch(recordsRequest)

        let trackers = Set(records.map {$0.tracker})
        
        var dict: [String: [Tracker]] = [:]
        
        trackers.forEach { object in
            let tracker = convertToTracker(object!)
            if dict[object?.category?.title ?? ""] != nil {
                dict[object?.category?.title ?? ""]?.append(tracker)
            } else {
                dict.updateValue([tracker], forKey: object?.category?.title ?? "")
            }
        }
            
        return dict
            .map { TrackerCategory(title: $0.key, trackers: $0.value.sorted(by: <)) }
            .sorted(by: <)
    }
    
    func fetchIncompleteTrackers(at weekday: String,_ stringDate: String) throws -> [TrackerCategory] {
        let recordsRequest = TrackerRecordCoreData.fetchRequest()
        recordsRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), stringDate)
        let records = try context.fetch(recordsRequest)

        let completedTrackers = Set(records.map {$0.tracker})
        
        let trackersRequest = TrackerCoreData.fetchRequest()
        trackersRequest.predicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(TrackerCoreData.schedule), weekday)
        
        let allTrackersAtToday = try context.fetch(trackersRequest)
        
        let incompleteTrackers = Set(allTrackersAtToday).subtracting(completedTrackers)
        
        var dict: [String: [Tracker]] = [:]
        
        incompleteTrackers.forEach { object in
            let tracker = convertToTracker(object!)
            if dict[object?.category?.title ?? ""] != nil {
                dict[object?.category?.title ?? ""]?.append(tracker)
            } else {
                dict.updateValue([tracker], forKey: object?.category?.title ?? "")
            }
        }
            
        return dict
            .map { TrackerCategory(title: $0.key, trackers: $0.value.sorted(by: <)) }
            .sorted(by: <)
    }
    
    func changeCategory(for uuid: String, isPinned: Bool) throws {
        
        let trackerRequest = TrackerCoreData.fetchRequest()
        trackerRequest.predicate = NSPredicate(format: "%K == %@" , #keyPath(TrackerCoreData.uuid), uuid)
        let tracker = try context.fetch(trackerRequest)[0]
        
        if isPinned {
            
            let categoryRequest = TrackerCategoryCoreData.fetchRequest()
            categoryRequest.predicate = NSPredicate(
                format: "%K == %@"
                , #keyPath(TrackerCategoryCoreData.title),
                tracker.lastCategory ?? ""
            )
            let categories = try context.fetch(categoryRequest)
            
            if categories.isEmpty {
                let pinCategory = TrackerCategoryCoreData(context: context)
                pinCategory.title = tracker.lastCategory ?? ""
                tracker.category = pinCategory
            } else {
                let pinCategory = categories[0]
                tracker.category = pinCategory
            }
            
            tracker.lastCategory = nil
            
        } else {
            
            tracker.lastCategory = tracker.category?.title
            
            let categoryRequest = TrackerCategoryCoreData.fetchRequest()
            categoryRequest.predicate = NSPredicate(
                format: "%K == %@"
                , #keyPath(TrackerCategoryCoreData.title),
                L10n.Localizable.CollectionScreen.pinHeader
            )
            let categories = try context.fetch(categoryRequest)
            
            if categories.isEmpty {
                let pinCategory = TrackerCategoryCoreData(context: context)
                pinCategory.title = L10n.Localizable.CollectionScreen.pinHeader
                tracker.category = pinCategory
            } else {
                let pinCategory = categories[0]
                tracker.category = pinCategory
            }
        }
        
        try context.save()
        NotificationCenter.default.post(notification)
    }
    
    private func convertToTracker(_ object: TrackerCoreData) -> Tracker {
        if let id = object.uuid,
           let name = object.name,
           let color = object.color,
           let emoji = object.emoji,
           let rawValues = object.schedule {
            
            let schedule = rawValues.components(separatedBy: ",").compactMap { Int($0) }.compactMap { WeekDay(rawValue: $0)}
            return Tracker(
                uuid: UUID(uuidString: id) ?? UUID(),
                name: name,
                color: color,
                emoji: emoji,
                schedule: Set(schedule)
            )
        } else {
            fatalError("object doesn't exist")
        }
    }
}

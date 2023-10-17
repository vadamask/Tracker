//
//  TrackerStore.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.09.2023.
//

import CoreData
import UIKit

final class TrackerStore {
    
    private let context: NSManagedObjectContext
    private var notification = Notification(name: Notification.Name("Trackers changed"))
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Failed with context")
        }
        self.init(context: context)
    }
    
    func fetchCategoriesWithTrackers(at weekday: String) throws -> [TrackerCategory] {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(TrackerCoreData.schedule), weekday)
        
        let objects = try context.fetch(request)
        let pinnedTrackers = objects.filter { $0.isPinned }
        let unpinnedTrackers = objects.filter { !$0.isPinned }
        
        let dict = convertToCategories(objects: unpinnedTrackers)
        
        var result: [TrackerCategory] = []
        
        if !pinnedTrackers.isEmpty {
            result.append(
                TrackerCategory(
                    title: L10n.Localizable.CollectionScreen.pinHeader,
                    trackers: pinnedTrackers.map { convertToTracker($0) }
                )
            )
        }
            
        result.append(
            contentsOf: dict
                .map { TrackerCategory(title: $0.key, trackers: $0.value) }
                .sorted(by: <)
        )
        
        return result
    }
    
    func fetchTracker(with id: String) throws -> (TrackerCategory, Int) {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@" , #keyPath(TrackerCoreData.uuid), id)
        let object = try context.fetch(request)[0]
        let records = object.records?.count
        
        return (
            TrackerCategory(title: object.category?.title ?? "", trackers: [convertToTracker(object)]),
            records ?? 0
        )
    }
    
    func addTracker(_ tracker: Tracker, with categoryTitle: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), categoryTitle)
        let categories = try context.fetch(request)
        guard !categories.isEmpty else { throw StoreError.categoriesIsEmpty }
        
        let object = TrackerCoreData(context: context)
        object.uuid = tracker.id.uuidString
        object.color = tracker.color
        object.emoji = tracker.emoji
        object.name = tracker.name
        object.isPinned = tracker.isPinned
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
            model.trackers[0].id.uuidString
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
    
    func deleteTracker(with id: String) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@" , #keyPath(TrackerCoreData.uuid), id)
        let trackers = try context.fetch(request)
        context.delete(trackers[0])
        try context.save()
        NotificationCenter.default.post(notification)
    }
    
    func pinTracker(with id: String, isPinned: Bool) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@" , #keyPath(TrackerCoreData.uuid), id)
        let trackers = try context.fetch(request)
        
        guard !trackers.isEmpty else { return }
        
        trackers[0].isPinned = !isPinned
        try context.save()
        NotificationCenter.default.post(notification)
    }
    
    func fetchCompletedTrackers(today: String) throws -> [TrackerCategory] {
        
        let recordsRequest = TrackerRecordCoreData.fetchRequest()
        recordsRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), today)
        let records = try context.fetch(recordsRequest)

        let trackers = Set(records.map { $0.tracker }.compactMap { $0 })
        let pinnedTrackers = trackers.filter { $0.isPinned }
        let unpinnedTrackers = trackers.subtracting(pinnedTrackers)
        
        let dict = convertToCategories(objects: Array(unpinnedTrackers))
            
        var result: [TrackerCategory] = []
        
        if !pinnedTrackers.isEmpty {
            result.append(
                TrackerCategory(
                    title: L10n.Localizable.CollectionScreen.pinHeader,
                    trackers: pinnedTrackers.map { convertToTracker($0) }
                )
            )
        }
            
        result.append(
            contentsOf: dict
                .map { TrackerCategory(title: $0.key, trackers: $0.value) }
                .sorted(by: <)
        )
        
        return result
    }
    
    func fetchIncompleteTrackers(at weekday: String,_ stringDate: String) throws -> [TrackerCategory] {
        
        let recordsRequest = TrackerRecordCoreData.fetchRequest()
        recordsRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), stringDate)
        let records = try context.fetch(recordsRequest)

        let trackersRequest = TrackerCoreData.fetchRequest()
        trackersRequest.predicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(TrackerCoreData.schedule), weekday)
        let allTrackersAtToday = try context.fetch(trackersRequest)
        
        let completedTrackers = Set(records.map {$0.tracker})
        let incompleteTrackers = Set(Set(allTrackersAtToday).subtracting(completedTrackers).compactMap { $0 })
        let pinnedTrackers = incompleteTrackers.filter { $0.isPinned }
        let unpinnedTrackers = incompleteTrackers.subtracting(pinnedTrackers)
        
        let dict = convertToCategories(objects: Array(unpinnedTrackers))
            
        var result: [TrackerCategory] = []
        
        if !pinnedTrackers.isEmpty {
            result.append(
                TrackerCategory(
                    title: L10n.Localizable.CollectionScreen.pinHeader,
                    trackers: pinnedTrackers.map { convertToTracker($0) }
                )
            )
        }
            
        result.append(
            contentsOf: dict
                .map { TrackerCategory(title: $0.key, trackers: $0.value) }
                .sorted(by: <)
        )
        
        return result
    }
    
    private func convertToTracker(_ object: TrackerCoreData) -> Tracker {
        if let id = object.uuid,
           let name = object.name,
           let color = object.color,
           let emoji = object.emoji,
           let rawValues = object.schedule {
            
            let schedule = rawValues.components(separatedBy: ",").compactMap { Int($0) }.compactMap { WeekDay(rawValue: $0)}
            return Tracker(
                id: UUID(uuidString: id) ?? UUID(),
                name: name,
                color: color,
                emoji: emoji,
                schedule: Set(schedule),
                isPinned: object.isPinned
            )
        } else {
            fatalError("object doesn't exist")
        }
    }
    
    private func convertToCategories(objects: [TrackerCoreData] ) -> [String: [Tracker]] {
        
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
    }
}

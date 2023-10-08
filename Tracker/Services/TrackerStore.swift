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
    private var notification = Notification(name: Notification.Name("trackers changed"))
    
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
            if let arr = dict[object.category?.title ?? ""] {
                dict[object.category?.title ?? ""]?.append(tracker)
            } else {
                dict.updateValue([tracker], forKey: object.category?.title ?? "")
            }
        }
            
        return dict
            .map { TrackerCategory(title: $0.key, trackers: $0.value) }
            .sorted {$0.title < $1.title}
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
    
    func deleteTracker(with uuid: String) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@" , #keyPath(TrackerCoreData.uuid), uuid)
        let trackers = try context.fetch(request)
        context.delete(trackers[0])
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

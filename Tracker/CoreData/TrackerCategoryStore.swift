//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.09.2023.
//

import UIKit
import CoreData

final class TrackerCategoryStore {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            self.init(context: context)
        } else {
            fatalError("Не удалось получить контекст")
        }
    }
    
    func add(_ title: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), title)
        let categories = try context.fetch(request)
        if categories.isEmpty {
            let categoryEntity = TrackerCategoryCoreData(context: context)
            categoryEntity.title = title
            try context.save()
        }
    }
    
    func fetchCategories() throws -> [TrackerCategory] {
        let request = TrackerCategoryCoreData.fetchRequest()
        let categories = try context.fetch(request)
        return categories.map { convertToModel($0) }
    }
    
    private func convertToModel(_ entity: TrackerCategoryCoreData) -> TrackerCategory {
        guard let title = entity.title, let trackers = entity.trackers as? Set<TrackerCoreData> else { fatalError() }
        
        return TrackerCategory(
            title: title,
            trackers: trackers.map { Tracker(id: $0.id!, name: $0.name!, color: $0.color!, emoji: $0.emoji!, schedule: Set($0.schedule!.map {WeekDay(rawValue: $0)!})) }
        )
    }
}

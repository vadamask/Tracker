//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.09.2023.
//

import CoreData
import UIKit

final class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    let context: NSManagedObjectContext
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private convenience override init() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Failed with context")
        }
        self.init(context: context)
    }
    
    func updateCategory(_ oldTitle: String?, with newTitle: String) throws {
        
        let request = TrackerCategoryCoreData.fetchRequest()
        
        if let oldTitle = oldTitle {
            if oldTitle == newTitle {
                throw StoreError.tryAddSameCategory
            }
            request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), oldTitle)
            let categories = try context.fetch(request)
            categories[0].title = newTitle
            try context.save()
            
        } else {
            
            request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), newTitle)
            let categories = try context.fetch(request)
        
            if categories.isEmpty {
                let categoryEntity = TrackerCategoryCoreData(context: context)
                categoryEntity.title = newTitle
                try context.save()
            } else {
                throw StoreError.tryAddSameCategory
            }
        }
    }
    
    func fetchObjects() throws -> [CategoryCellViewModel] {
        let request = TrackerCategoryCoreData.fetchRequest()
        let objects = try context.fetch(request)
        return objects.compactMap { CategoryCellViewModel(title: $0.title ?? "") }.sorted { $0.title < $1.title }
    }
    
    func deleteCategory(with title: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), title)
        let objects = try context.fetch(request)
        context.delete(objects[0])
        try context.save()
    }
}

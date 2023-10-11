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
    
    private var addNotification = Notification(name: Notification.Name("Category added"))
    private var changeNotification = Notification(name: Notification.Name("Category changed"))
    private var deleteNotification = Notification(name: Notification.Name("Category deleted"))
    
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
            NotificationCenter.default.post(changeNotification)
        } else {
            
            request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), newTitle)
            let categories = try context.fetch(request)
        
            if categories.isEmpty {
                let categoryEntity = TrackerCategoryCoreData(context: context)
                categoryEntity.title = newTitle
                try context.save()
                NotificationCenter.default.post(addNotification)
            } else {
                throw StoreError.tryAddSameCategory
            }
        }
    }
    
    func fetchCategories() throws -> [CategoryCellViewModel] {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K != %@",
            #keyPath(TrackerCategoryCoreData.title),
            L10n.Localizable.CollectionScreen.pinHeader
        )
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let objects = try context.fetch(request)
        return objects.compactMap { CategoryCellViewModel(title: $0.title ?? "") }
    }
    
    func deleteCategory(with title: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), title)
        let objects = try context.fetch(request)
        context.delete(objects[0])
        try context.save()
        NotificationCenter.default.post(deleteNotification)
    }
}

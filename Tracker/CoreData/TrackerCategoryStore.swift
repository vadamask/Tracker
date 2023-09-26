//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.09.2023.
//

import CoreData
import UIKit

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Failed with context")
        }
        self.init(context: context)
    }
    
    func addTitle(_ title: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), title)
        
        let categories = try context.fetch(request)
        
        if categories.isEmpty {
            let categoryEntity = TrackerCategoryCoreData(context: context)
            categoryEntity.title = title
            try context.save()
        } else {
            throw StoreError.tryAddSameCategory
        }
    }
    
    func getCategories() throws -> [CategoryCellViewModel] {
        let request = TrackerCategoryCoreData.fetchRequest()
        let categories = try context.fetch(request)
        return categories
            .compactMap { $0.title }
            .sorted()
            .map { CategoryCellViewModel(title: $0) }
    }
}

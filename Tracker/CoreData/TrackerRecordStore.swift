//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.09.2023.
//

import UIKit
import CoreData

final class TrackerRecordStore {
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
}

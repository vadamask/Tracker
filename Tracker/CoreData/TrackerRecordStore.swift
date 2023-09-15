//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.09.2023.
//

import CoreData
import UIKit

final class TrackerRecordStore {
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
    
    func addRecord(_ record: TrackerRecord) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.uuid), record.uuid.uuidString)
        let trackerObject = try? context.fetch(request)[0]
        
        let recordObject = TrackerRecordCoreData(context: context)
        recordObject.uuid = record.uuid.uuidString
        recordObject.date = record.date
        recordObject.tracker = trackerObject
        try context.save()
    }
    
    func removeRecord(with uuid: UUID, at date: String) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        let uuidPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.uuid), uuid.uuidString)
        let datePredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [uuidPredicate, datePredicate])
        request.predicate = compoundPredicate
        let records = try context.fetch(request)
        guard !records.isEmpty else { return }
        context.delete(records[0])
        try context.save()
    }
}

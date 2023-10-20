//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.09.2023.
//

import CoreData
import UIKit

struct StatisticsResult {
    let bestPeriod: Int
    let perfectDays: Int
    let completedTrackers: Int
    let avgValue: Int
}

struct Details {
    let isDone: Bool
    let completedDays: Int
    let recordID: UUID?
}

final class TrackerRecordStore {
    
    private let context: NSManagedObjectContext
    private let notification = Notification(name: .recordsChanged)
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        formatter.locale = .current
        return formatter
    }()
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Failed with context")
        }
        self.init(context: context)
    }
    
    func addRecord(_ record: TrackerRecord, for trackerID: UUID) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.uuid), trackerID.uuidString)
        let trackerObject = try context.fetch(request)[0]
        
        let recordObject = TrackerRecordCoreData(context: context)
        recordObject.uuid = record.id.uuidString
        recordObject.date = record.date
        recordObject.tracker = trackerObject
        try context.save()
        
        NotificationCenter.default.post(notification)
    }
    
    func deleteRecord(with id: UUID) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.uuid), id.uuidString)
        let records = try context.fetch(request)
        context.delete(records[0])
        try context.save()
        
        NotificationCenter.default.post(notification)
    }
    
    func detailsFor(_ trackerID: UUID, at date: String) throws -> Details {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.uuid), trackerID.uuidString)
        let trackers = try context.fetch(request)
        let records = trackers[0].records as? Set<TrackerRecordCoreData>
        
        if let records = records,
           let index = records.firstIndex(where: { $0.date == date }),
           let stringID = records[index].uuid,
           let id = UUID(uuidString: stringID) {
            return Details(
                isDone: true,
                completedDays: records.count,
                recordID: id
            )
        } else {
            return Details(
                isDone: false,
                completedDays: records?.count ?? 0,
                recordID: nil
            )
        }
    }
    
    func getStatistics() throws -> StatisticsResult? {
        
        let request = TrackerRecordCoreData.fetchRequest()
        let records = try context.fetch(request)
        
        guard !records.isEmpty else { 
            return nil
        }
        
        let recordsPerDay = getRecordsPerDay(for: records)
        let avgValue = getAverageValue(for: recordsPerDay).rounded()
        let perfectDays = try getPerfectDays(for: recordsPerDay)
        
        guard !perfectDays.isEmpty else {
            return StatisticsResult(
                bestPeriod: 0,
                perfectDays: 0,
                completedTrackers: records.count,
                avgValue: Int(avgValue)
            )
        }
        
        let bestPeriod = getBestPeriod(for: perfectDays)
        
        return StatisticsResult(
            bestPeriod: bestPeriod,
            perfectDays: perfectDays.count,
            completedTrackers: records.count,
            avgValue: Int(avgValue)
        )
    }
    
    private func getRecordsPerDay(for records: [TrackerRecordCoreData]) -> [String: Int] {
        
        var trackersPerDate: [String: Int] = [:]
        
        records.forEach { record in
            if let date = record.date {
                if trackersPerDate[date] != nil {
                    trackersPerDate[date]? += 1
                } else {
                    trackersPerDate[date] = 1
                }
            }
        }
        
        return trackersPerDate
    }
    
    private func getAverageValue(for days: [String: Int]) -> Double {
        let sum = days.reduce(0) { partialResult, day in
            partialResult + day.value
        }
        return Double(sum) / Double(days.count)
    }
    
    private func getPerfectDays(for days: [String: Int]) throws -> [Date] {
 
        var perfectDays: [Date] = []
        
        for day in days {
            let date = dateFormatter.date(from: day.key)
            let weekday = date?.weekday
            
            let request = TrackerCoreData.fetchRequest()
            request.predicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(TrackerCoreData.schedule), weekday ?? "-1")
            let trackers = try context.fetch(request)
            
            if day.value == trackers.count {
                perfectDays.append(date ?? Date())
            }
        }
        return perfectDays.sorted()
    }
        
    private func getBestPeriod(for days: [Date]) -> Int {
        
        var lastBestPeriod = 1
        var bestPeriod = 1
        var lastDate = days[0]
        
        for currentDate in days.dropFirst() {
            if currentDate.timeIntervalSince1970 - lastDate.timeIntervalSince1970 == 86400 {
                bestPeriod += 1
            } else {
                lastBestPeriod = max(lastBestPeriod, bestPeriod)
                bestPeriod = 1
                
            }
            lastDate = currentDate
        }
        
        return max(lastBestPeriod, bestPeriod)
    }
}

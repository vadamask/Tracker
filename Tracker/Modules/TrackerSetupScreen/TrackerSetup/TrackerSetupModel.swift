//
//  TrackerSetupModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 29.09.2023.
//

import Foundation

final class TrackerSetupModel {
    
    var isAllSetup: Bool {
        guard title != nil,
              category != nil,
              color != nil,
              emoji != nil,
              schedule != nil else { return false }
        return true
    }
    
    private let trackerStore = TrackerStore()
    private var title: String?
    private var category: String?
    private var schedule: Set<WeekDay>?
    private var color: String?
    private var emoji: String?
    private var isPinned = false
    
    func addTracker() {
        if isAllSetup {
            let tracker = Tracker(
                id: UUID(),
                name: title!,
                color: color!,
                emoji: emoji!,
                schedule: schedule!,
                isPinned: isPinned
            )
            do {
                try trackerStore.addTracker(tracker, with: category!)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func replaceTracker(with id: UUID) throws {
        if isAllSetup {
            let tracker = Tracker(
                id: id,
                name: title!,
                color: color!,
                emoji: emoji!,
                schedule: schedule!,
                isPinned: isPinned
            )
            
            try trackerStore.changeTracker(with: TrackerCategory(title: category!, trackers: [tracker]))
        }
    }
    
    func textTooLong(_ text: String) -> Bool {
        text.count <= 38 ? false : true
    }
    
    func textDidChanged(_ text: String) {
        if text.isEmpty || textTooLong(text) {
            self.title = nil
        } else {
            self.title = text
        }
    }
    
    func eventIsSelected() {
        schedule = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    }
    
    func didSelectCategory(_ category: String) {
        self.category = category
    }
    
    func didSelectSchedule(_ schedule: Set<WeekDay>) {
        self.schedule = schedule
    }
    
    func didDeselectCategory() {
        self.category = nil
    }
    
    func didDeselectSchedule() {
        self.schedule = nil
    }
    
    func didSelectEmoji(_ emoji: String) {
        self.emoji = emoji
    }
    
    func didSelectColor(at indexPath: IndexPath) {
        self.color = "Color selection \(indexPath.row)"
    }
    
    func didDeselectEmoji() {
        self.emoji = nil
    }
    
    func didDeselectColor() {
        self.color = nil
    }
    
    func trackerIsPinned(_ isPinned: Bool) {
        self.isPinned = isPinned
    }
}

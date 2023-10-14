//
//  StatisticViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 14.10.2023.
//

import Foundation

final class StatisticViewModel {
    
    @Observable var emptyState = true
    @Observable var statistics: StatisticsResult?
    
    private let recordStore = TrackerRecordStore()
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateView),
            name: Notification.Name("Records changed"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateView),
            name: Notification.Name("Trackers changed"),
            object: nil
        )
    }
    
    @objc func updateView() {
        do {
            statistics = try recordStore.getStatistics()
        } catch {
            print(error.localizedDescription)
        }
        
        emptyState = statistics == nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

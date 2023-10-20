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
    @Observable var error: Error?
    
    private let recordStore = TrackerRecordStore()
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateView),
            name: .recordsChanged,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateView),
            name: .trackersChanged,
            object: nil
        )
    }
    
    @objc
    func updateView() {
        do {
            statistics = try recordStore.getStatistics()
        } catch {
            self.error = error
        }
        emptyState = statistics == nil
    }
    
    func addMock() {
        statistics = StatisticsResult(
            bestPeriod: 1,
            perfectDays: 2,
            completedTrackers: 3,
            avgValue: 4
        )
        emptyState = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

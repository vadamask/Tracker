//
//  ScheduleViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.09.2023.
//

import Foundation

final class ScheduleViewModel {
    
    var schedule: [ScheduleCellViewModel] = [
        ScheduleCellViewModel(day: .monday, isOn: false),
        ScheduleCellViewModel(day: .tuesday, isOn: false),
        ScheduleCellViewModel(day: .wednesday, isOn: false),
        ScheduleCellViewModel(day: .thursday, isOn: false),
        ScheduleCellViewModel(day: .friday, isOn: false),
        ScheduleCellViewModel(day: .saturday, isOn: false),
        ScheduleCellViewModel(day: .sunday, isOn: false)
    ]
    
    var numberOfRows: Int {
        schedule.count
    }
    
    var selectedDays: Set<WeekDay> {
        Set(schedule.filter { $0.isOn }.map { $0.day })
    }
    
    func viewModel(at indexPath: IndexPath) -> ScheduleCellViewModel {
        schedule[indexPath.row]
    }
    
    func setSchedule(_ schedule: Set<WeekDay>) {
        schedule.forEach { weekday in
            let viewModel = self.schedule.first(where: {$0.day == weekday})
            viewModel?.isOn = true
        }
    }
}

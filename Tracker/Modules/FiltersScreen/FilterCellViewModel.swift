//
//  FilterCellViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.10.2023.
//

import Foundation

final class FilterCellViewModel {
    var title: String
    @Observable var isSelected: Bool = false
    
    init(title: String) {
        self.title = title
    }
}

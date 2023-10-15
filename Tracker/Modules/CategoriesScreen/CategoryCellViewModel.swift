//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 25.09.2023.
//

import Foundation

final class CategoryCellViewModel {
    @Observable var title: String
    @Observable var isSelected: Bool = false
    
    init(title: String) {
        self.title = title
    }
}

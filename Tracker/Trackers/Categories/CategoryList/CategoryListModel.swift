//
//  TrackerCategoryModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.09.2023.
//

import Foundation

final class CategoryListModel {
    
    private let categoryStore = TrackerCategoryStore.shared
    
    func fetchObjects() -> [CategoryCellViewModel] {
        do {
            let titles = try categoryStore.fetchObjects()
            return titles
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    
}

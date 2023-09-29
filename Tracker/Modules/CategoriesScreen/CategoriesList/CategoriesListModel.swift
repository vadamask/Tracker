//
//  TrackerCategoryModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.09.2023.
//

import Foundation

final class CategoriesListModel {
    
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
    
    func deleteCategory(with title: String) {
        do {
            try categoryStore.deleteCategory(with: title)
        } catch {
            print(error.localizedDescription)
        }
    }
}

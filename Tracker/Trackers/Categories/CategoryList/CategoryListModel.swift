//
//  TrackerCategoryModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.09.2023.
//

import Foundation

final class CategoryListModel {
    
    private let categoryStore = TrackerCategoryStore()
    
    func getCategories() -> [CategoryCellViewModel] {
        do {
            let titles = try categoryStore.getCategories()
            return titles
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func addCategory(with title: String) throws {
        try categoryStore.addTitle(title)
    }
}

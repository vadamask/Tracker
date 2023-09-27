//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.09.2023.
//

import Foundation

final class CategoryListViewModel: TrackerCategoryStoreDelegate {
    
    let model: CategoryListModel
    var categoryStore = TrackerCategoryStore.shared
    
    @Observable var categories: [CategoryCellViewModel]?
    
    init(model: CategoryListModel) {
        self.model = model
        categoryStore.delegate = self
    }
    
    func getCategories() {
        categories = model.getCategories()
    }
    
    func didUpdate() {
        getCategories()
    }
}

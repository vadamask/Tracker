//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.09.2023.
//

import Foundation

final class CategoryListViewModel {
    
    let model: CategoryListModel
    
    @Observable var categories: [CategoryCellViewModel]?
    @Observable var isSameCategory: Bool?
    
    init(model: CategoryListModel) {
        self.model = model
    }
    
    func getCategories() {
        categories = model.getCategories()
    }
    
    func addCategory(with title: String) {
        do {
            try model.addCategory(with: title)
            isSameCategory = false
            
            let cellViewModel = CategoryCellViewModel(title: title)
            
            if let index = categories?.firstIndex(where: { cellViewModel.title < $0.title }) {
                self.categories?.insert(cellViewModel, at: index)
            } else {
                categories?.append(cellViewModel)
            }
            
        } catch StoreError.tryAddSameCategory {
            isSameCategory = true
        } catch {
            print(error.localizedDescription)
        }
    }
}

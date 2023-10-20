//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.09.2023.
//

import Foundation

final class CategoriesListViewModel {
    
    @Observable var categories: [CategoryCellViewModel] = []
    @Observable var selectedCategory: String?
    private let model: CategoriesListModel
    
    init(model: CategoriesListModel, selectedCategory: String?) {
        self.model = model
        categories = model.fetchObjects()
        
        self.selectedCategory = selectedCategory
        if let category = categories.first(where: {$0.title == selectedCategory}) {
            category.isSelected = true
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchObjects),
            name: .categoryChanged,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchObjects),
            name: .categoryDeleted,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchObjects),
            name: .categoryAdded,
            object: nil
        )
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        categories.forEach { $0.isSelected = false }
        categories[indexPath.row].isSelected.toggle()
        selectedCategory = categories[indexPath.row].title
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        let title = categories[indexPath.row].title
        model.deleteCategory(with: title)
    }
    
    @objc
    private func fetchObjects() {
        categories = model.fetchObjects()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

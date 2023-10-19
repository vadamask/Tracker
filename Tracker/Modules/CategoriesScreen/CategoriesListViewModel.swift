//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.09.2023.
//

import Foundation

final class CategoriesListViewModel {
    
    private let model: CategoriesListModel
    
    @Observable var categories: [CategoryCellViewModel] = []
    @Observable var selectedCategory: String?
    
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
            name: Notification.Name.categoryChanged,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchObjects),
            name: Notification.Name.categoryDeleted,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchObjects),
            name: Notification.Name.categoryAdded,
            object: nil
        )
    }
    
    @objc private func fetchObjects() {
        categories = model.fetchObjects()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

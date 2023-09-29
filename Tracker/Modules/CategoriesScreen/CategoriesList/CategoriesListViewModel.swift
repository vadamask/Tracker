//
//  TrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.09.2023.
//

import Foundation

final class CategoriesListViewModel {
    
    let model: CategoriesListModel
    
    @Observable var categories: [CategoryCellViewModel]?
    @Observable var selectedTitle: String?
    
    init(model: CategoriesListModel) {
        self.model = model
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateView),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: TrackerCategoryStore.shared.context)
    }
    
    var numberOfRows: Int {
        categories?.count ?? 0
    }
    
    func viewModel(at indexPath: IndexPath) -> CategoryCellViewModel? {
        categories?[indexPath.row] 
    }
    
    func fetchObjects() {
        categories = model.fetchObjects()
    }
    
    @objc func updateView() {
        fetchObjects()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        if let index = categories?.firstIndex(where: { $0.isSelected }) {
            if index == indexPath.row {
                categories?[indexPath.row].isSelected.toggle()
                selectedTitle = nil
            } else {
                categories?.forEach { $0.isSelected = false }
                categories?[indexPath.row].isSelected.toggle()
                selectedTitle = categories?[indexPath.row].title
            }
        } else {
            categories?[indexPath.row].isSelected.toggle()
            selectedTitle = categories?[indexPath.row].title
        }
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        guard let title = categories?[indexPath.row].title else { return }
        model.deleteCategory(with: title)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

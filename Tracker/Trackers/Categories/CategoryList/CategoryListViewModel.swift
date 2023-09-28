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
    @Observable var selectedTitle: String?
    
    init(model: CategoryListModel) {
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
                selectedTitle = ""
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
}

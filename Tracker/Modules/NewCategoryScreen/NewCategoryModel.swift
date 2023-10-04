//
//  NewCategoryModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 26.09.2023.
//

import Foundation

final class NewCategoryModel {
    
    private let categoryStore = TrackerCategoryStore.shared
       
    func validateText(_ text: String?) -> Bool {
        guard let text = text else { return false }
        return text.isEmpty ? false : true
    }
    
    func updateCategory(_ oldTitle: String?, with newTitle: String) -> Result<Void, Error> {
        if oldTitle == newTitle {
            return .failure(StoreError.tryAddSameCategory)
        }
        do {
            try categoryStore.updateCategory(oldTitle, with: newTitle)
            return .success(())
        } catch {
            print(error.localizedDescription)
            return .failure(error)
        }
    }
}

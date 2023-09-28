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
    
    func addCategory(with title: String) -> Result<Void, Error> {
        do {
            try categoryStore.addTitle(title)
            return .success(())
        } catch StoreError.tryAddSameCategory {
            return .failure(StoreError.tryAddSameCategory)
        } catch {
            return .failure(error)
        }
    }
}

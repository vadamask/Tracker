//
//  NewCategoryViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 25.09.2023.
//

import Foundation

final class NewCategoryViewModel {
    
    @Observable var isAllowed: Bool = false
    @Observable var isSameCategory: Bool?
    
    private let model: NewCategoryModel
    
    init(model: NewCategoryModel) {
        self.model = model
    }
    
    func didChange(text: String?) {
        isAllowed = model.validateText(text)
    }
    
    func addCategory(with title: String) {
        do {
            try model.addCategory(with: title)
            isSameCategory = false
        } catch StoreError.tryAddSameCategory {
            isSameCategory = true
        } catch {
            print(error.localizedDescription)
        }
    }
}

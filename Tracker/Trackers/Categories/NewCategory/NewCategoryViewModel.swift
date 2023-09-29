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
    
    func textDidChanged(_ text: String?) {
        isAllowed = model.validateText(text)
    }
    
    func updateCategory(_ oldTitle: String?, with newTitle: String) {
        switch model.updateCategory(oldTitle, with: newTitle) {
        case .success(_):
            isSameCategory = false
        case .failure(let error):
            if case StoreError.tryAddSameCategory = error {
                isSameCategory = true
            } else {
                print(error.localizedDescription)
            }
        }
    }
}


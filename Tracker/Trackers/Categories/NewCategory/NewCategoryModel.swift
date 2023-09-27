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
        
        if text.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func addCategory(with title: String) throws {
        try categoryStore.addTitle(title)
    }
}

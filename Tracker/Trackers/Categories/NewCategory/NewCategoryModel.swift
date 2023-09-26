//
//  NewCategoryModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 26.09.2023.
//

import Foundation

final class NewCategoryModel {
       
    func validateText(_ text: String?) -> Bool {
        guard let text = text else { return false }
        
        if text.isEmpty {
            return false
        } else {
            return true
        }
    }
}

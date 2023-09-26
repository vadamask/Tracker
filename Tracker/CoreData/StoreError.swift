//
//  StoreError.swift
//  Tracker
//
//  Created by Вадим Шишков on 26.09.2023.
//

import Foundation

enum StoreError: Error {
    case categoriesIsEmpty
    case tryAddSameCategory
}

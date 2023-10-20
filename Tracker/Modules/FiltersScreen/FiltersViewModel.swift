//
//  FiltersViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.10.2023.
//

import Foundation

enum Filter: Int {
    case all
    case today
    case completed
    case incomplete
}

final class FiltersViewModel {
    
    @Observable var filter: Filter?
    
    @Observable var filters: [FilterCellViewModel] = [
        FilterCellViewModel(title: L10n.Localizable.FiltersScreen.Filter.all),
        FilterCellViewModel(title: L10n.Localizable.FiltersScreen.Filter.today),
        FilterCellViewModel(title: L10n.Localizable.FiltersScreen.Filter.completed),
        FilterCellViewModel(title: L10n.Localizable.FiltersScreen.Filter.incomplete)
    ]
    
    func didSelectRow(at indexPath: IndexPath) {
        filters[indexPath.row].isSelected.toggle()
        filter = Filter(rawValue: indexPath.row)
    }
    
    func setCheckmark(for filter: Filter) {
        filters[filter.rawValue].isSelected.toggle()
    }
}


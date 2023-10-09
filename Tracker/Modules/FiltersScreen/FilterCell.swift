//
//  FiltersViewModel.swift
//  Tracker
//
//  Created by Вадим Шишков on 09.10.2023.
//

import UIKit

final class FilterCell: UITableViewCell {
    
    var viewModel: FilterCellViewModel? {
        didSet {
            setupView()
            bind()
        }
    }
    
    private func setupView() {
        textLabel?.text = viewModel?.title
        textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        textLabel?.textColor = .blackYP
        
        backgroundColor = .backgroundYP
        selectionStyle = .none
        accessoryType = .none
        
        if let isSelected = viewModel?.isSelected {
            accessoryType = isSelected ? .checkmark : .none
        }
    }
    
    private func bind() {
        viewModel?.$isSelected.bind(action: { [weak self] isSelected in
            self?.accessoryType = isSelected ? .checkmark : .none
        })
    }
    
}

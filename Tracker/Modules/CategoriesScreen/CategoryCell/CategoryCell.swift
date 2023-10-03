//
//  CategoryCellView.swift
//  Tracker
//
//  Created by Вадим Шишков on 25.09.2023.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    static let identifier = "cell"
    
    var viewModel: CategoryCellViewModel? {
        didSet {
            setupView()
            bind()
        }
    }
    
    private func setupView() {
        textLabel?.text = viewModel?.title
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textLabel?.textColor = .blackYP
        
        backgroundColor = .backgroundYP
        selectionStyle = .none
        accessoryType = .none
        
        if let isSelected = viewModel?.isSelected {
            accessoryType = isSelected ? .checkmark : .none
        }
    }
    
    private func bind() {
        viewModel?.$title.bind(action: { [weak self] title in
            self?.textLabel?.text = title
        })
        
        viewModel?.$isSelected.bind(action: { [weak self] selected in
            if selected {
                self?.accessoryType = .checkmark
            } else {
                self?.accessoryType = .none
            }
        })
    }
}

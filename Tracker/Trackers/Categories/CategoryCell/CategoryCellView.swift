//
//  CategoryCellView.swift
//  Tracker
//
//  Created by Вадим Шишков on 25.09.2023.
//

import UIKit

final class CategoryCellView: UITableViewCell {
    
    static let identifier = "cell"
    
    var viewModel: CategoryCellViewModel? {
        didSet {
            textLabel?.text = viewModel?.title
            textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            textLabel?.textColor = .blackYP
            
            backgroundColor = .backgroundYP
            selectionStyle = .none
        
            viewModel?.$title.bind(action: { [weak self] title in
                self?.textLabel?.text = title
            })
            
            viewModel?.$selected.bind(action: { [weak self] selected in
                if selected {
                    self?.accessoryType = .checkmark
                } else {
                    self?.accessoryType = .none
                }
            })
        }
    }
    
}

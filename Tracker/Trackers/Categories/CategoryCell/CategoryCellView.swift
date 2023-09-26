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
        
            viewModel?.$title.bind(action: { [weak self] title in
                self?.textLabel?.text = title
            })
        }
    }
    
}

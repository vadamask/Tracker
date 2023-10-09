//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 30.08.2023.
//

import UIKit

final class ScheduleCell: UITableViewCell {
    var completion: (() -> Void)?
    private let switcher = UISwitch()
    
    var viewModel: ScheduleCellViewModel? {
        didSet {
            setupView()
        }
    }
    
    private func setupView() {
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textLabel?.textColor = .blackYP
        textLabel?.text = viewModel?.day.fullName
        backgroundColor = .backgroundYP
        
        switcher.onTintColor = .blueYP
        switcher.addTarget(self, action: #selector(switchTapped), for: .touchUpInside)
        switcher.isOn = viewModel?.isOn ?? false
        self.accessoryView = switcher
    }
    
    @objc private func switchTapped() {
        viewModel?.switchTapped(switcher.isOn)
        completion?()
    }
}

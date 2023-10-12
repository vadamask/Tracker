//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 30.08.2023.
//

import UIKit

final class ScheduleCell: UITableViewCell {
    var completion: (() -> Void)?
    var viewModel: ScheduleCellViewModel? {
        didSet {
            setupView()
        }
    }
    private let switcher = UISwitch()
    private let colors = Colors.shared
    
    private func setupView() {
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textLabel?.textColor = colors.blackDynamicYP
        textLabel?.text = viewModel?.day.fullName
        backgroundColor = colors.backgroundDynamicYP
        
        switcher.onTintColor = colors.blueStaticYP
        switcher.addTarget(self, action: #selector(switchTapped), for: .touchUpInside)
        switcher.isOn = viewModel?.isOn ?? false
        self.accessoryView = switcher
    }
    
    @objc private func switchTapped() {
        viewModel?.switchTapped(switcher.isOn)
        completion?()
    }
}

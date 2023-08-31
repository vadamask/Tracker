//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 30.08.2023.
//

import UIKit

protocol ScheduleTableViewCellDelegate: AnyObject {
    func switchDidTapped(_ isOn: Bool, at row: Int)
}

final class ScheduleTableViewCell: UITableViewCell {
    
    weak var delegate: ScheduleTableViewCellDelegate?
    private var row: Int!

    private let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .blueYP
        switcher.addTarget(self, action: #selector(switchTapped), for: .touchUpInside)
        return switcher
    }()
    
    func configure(at row: Int) {
        self.row = row
        self.accessoryView = switcher
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textLabel?.textColor = .blackYP
        backgroundColor = .backgroundYP
    }
    
    @objc private func switchTapped() {
        delegate?.switchDidTapped(switcher.isOn, at: row)
    }
}

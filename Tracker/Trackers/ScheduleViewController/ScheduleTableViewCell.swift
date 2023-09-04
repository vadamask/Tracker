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
    
    func configure(at row: Int, isOn: Bool) {
        self.row = row
        switcher.isOn = isOn
        self.accessoryView = switcher
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textLabel?.textColor = .blackYP
        backgroundColor = .backgroundYP
        if row == 6 {
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 400)
            layer.cornerRadius = 16
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    @objc private func switchTapped() {
        delegate?.switchDidTapped(switcher.isOn, at: row)
    }
}

//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 30.08.2023.
//

import UIKit

protocol TrackerScheduleTableViewCellDelegate: AnyObject {
    func switchDidTapped(_ isOn: Bool, at row: Int)
}

final class TrackerScheduleTableViewCell: UITableViewCell {
    
    weak var delegate: TrackerScheduleTableViewCellDelegate?
    private var row: Int?
    private let switcher = UISwitch()
    
    func configure(at row: Int, isOn: Bool) {
        self.row = row
        switcher.isOn = isOn
        switcher.onTintColor = .blueYP
        switcher.addTarget(self, action: #selector(switchTapped), for: .touchUpInside)
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
        delegate?.switchDidTapped(switcher.isOn, at: row ?? 0)
    }
}

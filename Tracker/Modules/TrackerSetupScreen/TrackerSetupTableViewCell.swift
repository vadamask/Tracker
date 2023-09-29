//
//  TrackersSetupCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 30.08.2023.
//

import UIKit

final class TrackerSetupTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundYP
        accessoryType = .disclosureIndicator
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textLabel?.textColor = .blackYP
        layer.cornerRadius = 16
        detailTextLabel?.textColor = .grayYP
        detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

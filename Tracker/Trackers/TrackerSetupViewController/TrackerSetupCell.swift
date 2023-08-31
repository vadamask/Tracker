//
//  TrackersSetupCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 30.08.2023.
//

import UIKit


final class TrackerSetupCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

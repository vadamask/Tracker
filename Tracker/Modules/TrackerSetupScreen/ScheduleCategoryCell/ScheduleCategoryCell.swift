//
//  TrackersSetupCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 30.08.2023.
//

import UIKit

final class ScheduleCategoryCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with row: Int, isTracker: Bool) {
        backgroundColor = .backgroundYP
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textLabel?.textColor = .blackYP
        
        layer.cornerRadius = 16
        
        detailTextLabel?.textColor = .grayYP
        detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        if row == 0 {
            textLabel?.text = L10n.Localizable.SetupTrackerScreen.Category.title
            layer.maskedCorners = isTracker ?
            [.layerMinXMinYCorner, .layerMaxXMinYCorner] :
            [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            
            if !isTracker {
                separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 400)
            }
        } else {
            textLabel?.text = L10n.Localizable.SetupTrackerScreen.Schedule.title
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 400)
        }
    }
    
    func setDetailTextLabel(for days: [String]) {
        detailTextLabel?.text = days.count < 7 ?
        days.joined(separator: ", ") :
        L10n.Localizable.everyday
    }
}

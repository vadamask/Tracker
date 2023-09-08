//
//  TrackerSetupColorCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 07.09.2023.
//

import UIKit

final class TrackerSetupColorCell: UICollectionViewCell {
    static let identifier = "ColorCell"
    
    private let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(view)
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with index: Int) {
        view.backgroundColor = UIColor(named: "Color selection \(index)")
        view.layer.cornerRadius = 8
    }
}

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
    
    private let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0.3
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 8
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backView)
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            backView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backView.widthAnchor.constraint(equalTo: widthAnchor),
            backView.heightAnchor.constraint(equalTo: heightAnchor),
            
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.widthAnchor.constraint(equalToConstant: 40),
            view.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with index: Int) {
        view.backgroundColor = UIColor(named: "Color selection \(index)")
        view.layer.cornerRadius = 8
        backView.layer.borderColor = UIColor(named: "Color selection \(index)")?.cgColor
    }
    
    func itemDidSelect(_ isSelect: Bool) {
        backView.isHidden = isSelect ? false : true
    }
}

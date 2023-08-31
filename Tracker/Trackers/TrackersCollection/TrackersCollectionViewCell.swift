//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 28.08.2023.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrackersCollectionViewCell"
    
    private let cardView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blueYP
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let quantityView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let emojiBackground: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        view.alpha = 0.3
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let pinImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pin symbol"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .whiteYP
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blackYP
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "add day button"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: TrackerCategory) {
        titleLabel.text = category.trackers[0].name
        emojiLabel.text = category.trackers[0].emoji
        cardView.backgroundColor = UIColor(named: category.trackers[0].color)
        dayLabel.text = "0 дней"
        plusButton.tintColor = UIColor(named: category.trackers[0].color)
    }
    
    private func setupViews() {
        
    }
    
    private func setupConstraints() {
        contentView.addSubview(cardView)
        contentView.addSubview(quantityView)
        
        cardView.addSubview(emojiBackground)
        cardView.addSubview(emojiLabel)
        cardView.addSubview(pinImageView)
        cardView.addSubview(titleLabel)
        
        quantityView.addSubview(dayLabel)
        quantityView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            quantityView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            quantityView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            quantityView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            quantityView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            emojiBackground.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiBackground.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiBackground.heightAnchor.constraint(equalToConstant: 24),
            emojiBackground.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackground.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackground.centerYAnchor),
            
            pinImageView.centerYAnchor.constraint(equalTo: emojiBackground.centerYAnchor),
            pinImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -4),
            pinImageView.heightAnchor.constraint(equalTo: emojiBackground.heightAnchor),
            pinImageView.widthAnchor.constraint(equalTo: emojiBackground.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: emojiBackground.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: emojiBackground.bottomAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            dayLabel.leadingAnchor.constraint(equalTo: quantityView.leadingAnchor, constant: 12),
            dayLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            dayLabel.bottomAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: -24),
            dayLabel.heightAnchor.constraint(equalToConstant: 18),
            
            plusButton.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: quantityView.trailingAnchor, constant: -12),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
}

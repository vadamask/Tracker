//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 28.08.2023.
//

import UIKit

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func recordWillAdd(with id: UUID) -> Bool
    func recordWillRemove(with id: UUID) -> Bool
}

final class TrackersCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrackersCollectionViewCell"
    weak var delegate: TrackersCollectionViewCellDelegate?
    
    private var tracker: Tracker!
    private var isDone = false
    private var completedDays = 0 {
        didSet {
            dayLabel.text = "\(completedDays) \(correctStringForNumber(completedDays))"
        }
    }
    
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
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
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 17
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
    
    func configure(with tracker: Tracker, isDone: Bool) {
        self.tracker = tracker
        self.isDone = isDone
        completedDays = isDone ? 1 : 0
        titleLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        cardView.backgroundColor = UIColor(named: tracker.color)
        setupButton()
    }
    
    private func setupViews() {
        pinImageView.isHidden = true
        dayLabel.text = "\(completedDays) \(correctStringForNumber(completedDays))"
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
    
    @objc private func plusButtonTapped() {
        guard let delegate = delegate else { return }
        if isDone {
            if delegate.recordWillRemove(with: tracker.id) {
                plusButton.setImage(UIImage(named: "add day button"), for: .normal)
                plusButton.alpha = 1.0
                plusButton.backgroundColor = .clear
                completedDays -= 1
                isDone.toggle()
            }
        } else {
            if delegate.recordWillAdd(with: tracker.id) {
                plusButton.setImage(UIImage(named: "done"), for: .normal)
                plusButton.alpha = 0.3
                plusButton.backgroundColor = UIColor(named: tracker.color)
                completedDays += 1
                isDone.toggle()
            }
        }
    }
    
    private func correctStringForNumber(_ num: Int) -> String {
        switch num % 10 {
        case 1 where (num - 1) % 100 != 10:
            return "день"
        case 2 where (num - 2) % 100 != 10:
            return "дня"
        case 3 where (num - 3) % 100 != 10:
            return "дня"
        case 4 where (num - 4) % 100 != 10:
            return "дня"
        default:
            return "дней"
        }
    }
    
    private func setupButton() {
        if isDone {
            plusButton.setImage(UIImage(named: "done"), for: .normal)
            plusButton.alpha = 0.3
            plusButton.backgroundColor = UIColor(named: tracker.color)
            plusButton.tintColor = UIColor(named: tracker.color)
        } else {
            plusButton.setImage(UIImage(named: "add day button"), for: .normal)
            plusButton.backgroundColor = .whiteYP
            plusButton.tintColor = UIColor(named: tracker.color)
        }
    }
}

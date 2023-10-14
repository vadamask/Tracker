//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Вадим Шишков on 28.08.2023.
//

import SnapKit
import UIKit

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func willAddRecord(with uuid: UUID) -> Bool
    func willDeleteRecord(with uuid: UUID) -> Bool
}

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TrackersCollectionViewCell"
    weak var delegate: TrackersCollectionViewCellDelegate?
    private let analyticsService = AnalyticsService.shared
    private var tracker: Tracker?
    
    private let colors = Colors.shared
    private var isDone = false
    private(set) var cardView = UIView()
    private let quantityView = UIView()
    private let emojiBackground = UIView()
    private let pinView = UIImageView(image: UIImage(asset: Asset.Assets.Tracker.pinSymbol))
    private let emoji = UILabel()
    private let trackerName = UILabel()
    private let daysCount = UILabel()
    private let plusButton = UIButton()
    
    private var completedDays = 0 {
        didSet {
            daysCount.text = L10n.Localizable.numberOfDays(completedDays)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tracker: Tracker,_ details: (isDone: Bool, completedDays: Int), and isPinned: Bool) {
        self.tracker = tracker
        isDone = details.isDone
        completedDays = details.completedDays
        pinView.isHidden = !isPinned
        
        trackerName.text = tracker.name
        trackerName.textColor = colors.whiteStaticYP
        trackerName.font = .systemFont(ofSize: 12, weight: .medium)
        
        daysCount.textColor = colors.blackDynamicYP
        daysCount.font = .systemFont(ofSize: 12, weight: .medium)
        
        emoji.text = tracker.emoji
        cardView.backgroundColor = UIColor(named: tracker.color)
        setupButton()
    }
    
    var isPinned: Bool {
        get {
            !pinView.isHidden
        }
        set {
            pinView.isHidden = !newValue
        }
    }
      
    @objc private func recordButtonTapped() {
        guard let delegate = delegate else { return }
        if isDone {
            if delegate.willDeleteRecord(with: tracker?.uuid ?? UUID()) {
                plusButton.setImage(UIImage(asset: Asset.Assets.Tracker.addDayButton), for: .normal)
                plusButton.alpha = 1.0
                plusButton.backgroundColor = .clear
                completedDays -= 1
                isDone.toggle()
            }
        } else {
            if delegate.willAddRecord(with: tracker?.uuid ?? UUID()) {
                plusButton.setImage(UIImage(asset: Asset.Assets.Tracker.done), for: .normal)
                plusButton.alpha = 0.3
                plusButton.backgroundColor = UIColor(named: tracker?.color ?? "Black")
                completedDays += 1
                isDone.toggle()
            }
        }
        
        analyticsService.sendEvent(params: [
            "event": "click",
            "screen": "main",
            "item": "track"
        ])
    }
    
    private func setupButton() {
        if isDone {
            plusButton.setImage(UIImage(asset: Asset.Assets.Tracker.done), for: .normal)
            plusButton.alpha = 0.3
            plusButton.backgroundColor = UIColor(named: tracker?.color ?? "Black")
            plusButton.tintColor = UIColor(named: tracker?.color ?? "Black")
        } else {
            plusButton.setImage(UIImage(asset: Asset.Assets.Tracker.addDayButton), for: .normal)
            plusButton.alpha = 1.0
            plusButton.backgroundColor = colors.whiteDynamicYP
            plusButton.tintColor = UIColor(named: tracker?.color ?? "Black")
        }
    }
    
    private func setupViews() {
        pinView.isHidden = true
        quantityView.backgroundColor = .clear
        cardView.layer.cornerRadius = 16
        
        emojiBackground.layer.cornerRadius = 12
        emojiBackground.backgroundColor = .white
        emojiBackground.alpha = 0.3
        
        emoji.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        emoji.textAlignment = .center
        
        trackerName.numberOfLines = 0
        
        plusButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        plusButton.layer.cornerRadius = 17
    }
    
    private func setupLayout() {
        contentView.addSubview(cardView)
        contentView.addSubview(quantityView)
        
        cardView.addSubview(emojiBackground)
        cardView.addSubview(emoji)
        cardView.addSubview(pinView)
        cardView.addSubview(trackerName)
        
        quantityView.addSubview(daysCount)
        quantityView.addSubview(plusButton)
        
        cardView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        quantityView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(cardView.snp.bottom)
        }
        
        emojiBackground.snp.makeConstraints { make in
            make.leading.top.equalTo(12)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        emoji.snp.makeConstraints { make in
            make.center.equalTo(emojiBackground)
        }
            
        pinView.snp.makeConstraints { make in
            make.size.centerY.equalTo(emojiBackground)
            make.trailing.equalTo(-4)
        }

        trackerName.snp.makeConstraints { make in
            make.leading.equalTo(emojiBackground)
            make.trailing.bottom.equalTo(-12)
            make.top.equalTo(emojiBackground.snp.bottom).offset(8)
        }
        
        daysCount.snp.makeConstraints { make in
            make.leading.equalTo(12)
            make.top.equalTo(16)
            make.bottom.equalTo(-24)
            make.height.equalTo(18)
        }
            
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 34, height: 34))
            make.centerY.equalTo(daysCount)
            make.trailing.equalTo(-12)
        }
    }
}

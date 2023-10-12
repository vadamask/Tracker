//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import SnapKit
import UIKit

final class StatisticsViewController: UIViewController {
    
    private let colors = Colors.shared
    private let placeholder = UIImageView(
        image: UIImage(asset: Asset.Assets.StatisticsScreen.emptyStatistics)
    )
    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = colors.whiteDynamicYP
        navigationItem.title = L10n.Localizable.StatisticsScreen.NavigationItem.title
        
        label.textAlignment = .center
        label.text = L10n.Localizable.StatisticsScreen.EmptyState.title
        label.textColor = colors.blackDynamicYP
        label.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private func setupLayout() {
        view.addSubview(placeholder)
        view.addSubview(label)
        
        placeholder.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(placeholder.snp.bottom).offset(8)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
    }
}

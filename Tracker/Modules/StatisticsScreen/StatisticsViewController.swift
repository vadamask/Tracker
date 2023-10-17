//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import SnapKit
import UIKit

final class StatisticsViewController: UIViewController {
    
    private let viewModel = StatisticViewModel()
    private let colors = Colors.shared
    private let analyticsService = AnalyticsService.shared
    private var test: Bool
    private let placeholder = UIImageView(
        image: UIImage(asset: Asset.Assets.StatisticsScreen.emptyStatistics)
    )
    private let label = UILabel()
    private let stackView = UIStackView()
    private let bestPeriodView = StatisticView(text: L10n.Localizable.StatisticsScreen.bestPeriod)
    private let perfectDaysView = StatisticView(text: L10n.Localizable.StatisticsScreen.perfectDays)
    private let trackersCompletedView = StatisticView(text: L10n.Localizable.StatisticsScreen.trackersCompleted)
    private let avgValueView = StatisticView(text: L10n.Localizable.StatisticsScreen.avgValue)
    
    init(test: Bool = false) {
        self.test = test
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        bind()
        
        if test {
            viewModel.addMock()
        } else {
            viewModel.updateView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.sendEvent(params: [
            "event": "open",
            "screen": "statistics"
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.sendEvent(params: [
            "event": "closed",
            "screen": "statistics"
        ])
    }
    
    private func bind() {
        viewModel.$statistics.bind { [weak self] statistics in
            guard let statistics = statistics else { return }
            
            self?.trackersCompletedView.changeText(String(statistics.completedTrackers))
            self?.perfectDaysView.changeText(String(statistics.perfectDays))
            self?.bestPeriodView.changeText(String(statistics.bestPeriod))
            self?.avgValueView.changeText(String(statistics.avgValue))
        }
        
        viewModel.$emptyState.bind { [weak self] emptyState in
            self?.placeholder.isHidden = emptyState ? false : true
            self?.label.isHidden = emptyState ? false : true

            [self?.bestPeriodView, self?.perfectDaysView, self?.trackersCompletedView, self?.avgValueView]
                .forEach {
                    $0?.isHidden = emptyState ? true : false
                }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = colors.whiteDynamicYP
        navigationItem.title = L10n.Localizable.StatisticsScreen.NavigationItem.title
        
        label.textAlignment = .center
        label.text = L10n.Localizable.StatisticsScreen.EmptyState.title
        label.textColor = colors.blackDynamicYP
        label.font = .systemFont(ofSize: 12, weight: .medium)
        
        stackView.addArrangedSubview(bestPeriodView)
        stackView.addArrangedSubview(perfectDaysView)
        stackView.addArrangedSubview(trackersCompletedView)
        stackView.addArrangedSubview(avgValueView)
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
    }
    
    private func setupLayout() {
        view.addSubview(placeholder)
        view.addSubview(label)
        view.addSubview(stackView)
        
        placeholder.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(placeholder.snp.bottom).offset(8)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-126)
        }
    }
}

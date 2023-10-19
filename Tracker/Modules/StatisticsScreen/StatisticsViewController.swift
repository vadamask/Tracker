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
            AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.open.rawValue,
            AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.statistics.rawValue
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.sendEvent(params: [
            AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.closed.rawValue,
            AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.statistics.rawValue
        ])
    }
    
    private func bind() {
        viewModel.$statistics.bind { [weak self] statistics in
            guard let self = self,
                  let statistics = statistics else { return }
            
            trackersCompletedView.changeText(String(statistics.completedTrackers))
            perfectDaysView.changeText(String(statistics.perfectDays))
            bestPeriodView.changeText(String(statistics.bestPeriod))
            avgValueView.changeText(String(statistics.avgValue))
        }
        
        viewModel.$emptyState.bind { [weak self] emptyState in
            guard let self = self else { return }
            
            placeholder.isHidden = emptyState ? false : true
            label.isHidden = emptyState ? false : true

            [bestPeriodView, perfectDaysView, trackersCompletedView, avgValueView]
                .forEach {
                    $0?.isHidden = emptyState ? true : false
                }
        }
        
        viewModel.$error.bind { [weak self] error in
            guard let error = error else { return }
            self?.showAlert(error)
        }
    }
    
    private func showAlert(_ error: Error) {
        let alertController = UIAlertController(
            title: L10n.Localizable.StatisticsScreen.AlertController.title,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: L10n.Localizable.StatisticsScreen.AlertController.ok,
            style: .cancel
        )
        present(alertController, animated: true)
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

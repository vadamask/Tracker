//
//  TrackersListViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import SnapKit
import UIKit

final class TrackersCollectionViewController: UIViewController {

    private let viewModel = TrackersCollectionViewModel()
    private let analyticsService = AnalyticsService.shared
    private let params: GeometricParameters
    private let colors = Colors.shared
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let placeholder = UIImageView()
    private let placeholderLabel = UILabel()
    private let filterButton = UIButton(type: .system)
    
    private var test: Bool
    
    init(params: GeometricParameters, test: Bool = false) {
        self.params = params
        self.test = test
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupViews()
        setupLayout()
        bind()
        
        if test {
            viewModel.addMock()
        } else {
            viewModel.fetchTrackersAtCurrentDate()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.sendEvent(params: [
            AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.open.rawValue,
            AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.main.rawValue
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.sendEvent(params: [
            AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.closed.rawValue,
            AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.main.rawValue
        ])
    }
    
    private func bind() {

        viewModel.$categories.bind { [weak self] categories in
            guard let self = self else { return }
            
            if categories.isEmpty {
                placeholder.image = UIImage(asset: Asset.Assets.MainScreen.emptyList)
                placeholderLabel.text = L10n.Localizable.CollectionScreen.EmptyState.title
                placeholder.isHidden = false
                placeholderLabel.isHidden = false
                filterButton.isHidden = true
            } else {
                placeholder.isHidden = true
                placeholderLabel.isHidden = true
                filterButton.isHidden = false
            }
            collectionView.reloadData()
        }
        
        viewModel.$searchIsEmpty.bind { [weak self] isEmpty in
            guard let self = self else { return }
            
            if isEmpty {
                placeholder.image = UIImage(asset: Asset.Assets.MainScreen.emptySearchResult)
                placeholderLabel.text = L10n.Localizable.CollectionScreen.EmptySearch.title
                placeholder.isHidden = false
                placeholderLabel.isHidden = false
                filterButton.isHidden = false
            } else {
                placeholder.isHidden = true
                placeholderLabel.isHidden = true
                filterButton.isHidden = true
            }
        }
        
        viewModel.$filter.bind { [weak self] _ in
            self?.viewModel.fetchTrackersAtCurrentDate()
        }
        
        viewModel.$error.bind { [weak self] error in
            guard let error = error else { return }
            self?.showAlert(error)
        }
    }
    
    @objc private func addNewTracker() {
        let vc = NewTrackerViewController()
        vc.delegate = self
        present(vc, animated: true)
        
        analyticsService.sendEvent(params: [
            AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
            AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.main.rawValue,
            AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.add_track.rawValue
        ])
    }
    
    @objc private func datePickerDidChanged(sender: UIDatePicker) {
        viewModel.dateDidChanged(sender.date)
    }
    
    @objc private func filtersDidTapped() {
        let vc = FiltersViewController(filter: viewModel.filter)
        
        vc.completion = { [weak self] filter in
            guard let self = self else { return }
            
            viewModel.didSelectedFilter(filter)
            
            switch filter {
            case .all:
                
                analyticsService.sendEvent(params: [
                    AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                    AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.filters.rawValue,
                    AnalyticsService.Parameters.item.rawValue: AnalyticsService.Filter.all.rawValue
                ])
            case .today:
                
                analyticsService.sendEvent(params: [
                    AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                    AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.filters.rawValue,
                    AnalyticsService.Parameters.item.rawValue: AnalyticsService.Filter.today.rawValue
                ])
            case .completed:
                
                analyticsService.sendEvent(params: [
                    AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                    AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.filters.rawValue,
                    AnalyticsService.Parameters.item.rawValue: AnalyticsService.Filter.completed.rawValue
                ])
            case .incomplete:
                
                analyticsService.sendEvent(params: [
                    AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                    AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.filters.rawValue,
                    AnalyticsService.Parameters.item.rawValue: AnalyticsService.Filter.incomplete.rawValue
                ])
            }
        }
        present(vc, animated: true)
        
        analyticsService.sendEvent(params: [
            AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
            AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.main.rawValue,
            AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.filter.rawValue
        ])
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
    
    private func setupNavigationItem() {
        
        let leftItem = UIBarButtonItem(
            image: UIImage(asset: Asset.Assets.MainScreen.addTrackerButton),
            style: .plain,
            target: self,
            action: #selector(addNewTracker)
        )
        leftItem.tintColor = colors.blackDynamicYP
        
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerDidChanged(sender:)), for: .valueChanged)
        
        if test {
            datePicker.date = Date(timeIntervalSince1970: 1000000)
        }
        
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = L10n.Localizable.CollectionScreen.SearchBar.placeholder
        searchController.searchBar.setValue(
            L10n.Localizable.CollectionScreen.SearchBar.cancelButton,
            forKey: "cancelButtonText"
        )
        searchController.searchBar.delegate = self
        
        navigationItem.title = L10n.Localizable.CollectionScreen.NavigationItem.title
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupViews() {
        
        view.backgroundColor = colors.whiteDynamicYP
        
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = colors.blackDynamicYP
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        filterButton.setTitle(L10n.Localizable.CollectionScreen.filterButton, for: .normal)
        filterButton.backgroundColor = colors.blueStaticYP
        filterButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        filterButton.setTitleColor(colors.whiteStaticYP, for: .normal)
        filterButton.layer.cornerRadius = 16
        filterButton.addTarget(self, action: #selector(filtersDidTapped), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = colors.whiteDynamicYP
        collectionView.register(
            TrackersCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier
        )
        collectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.identifier
        )
    }
    
    private func setupLayout() {
        
        view.addSubview(collectionView)
        view.addSubview(filterButton)
        
        collectionView.addSubview(placeholder)
        collectionView.addSubview(placeholderLabel)
    
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        placeholder.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(placeholder.snp.bottom).offset(8)
            make.centerX.equalTo(view)
        }
        
        filterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.size.equalTo(CGSize(width: 114, height: 50))
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.categories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.categories[section].trackers.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
    
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCollectionViewCell.identifier,
            for: indexPath
        ) as? TrackersCollectionViewCell else { return UICollectionViewCell() }
            
        cell.delegate = self
        let tracker = viewModel.categories[indexPath.section].trackers[indexPath.row]
        
        let details = test ?
        Details(isDone: true, completedDays: 0, recordID: nil) :
        viewModel.detailsFor(tracker.id)
        
        guard let details = details else { return UICollectionViewCell() }
        cell.configure(with: tracker, and: details)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        let title = viewModel.categories[indexPath.section].title
        
        if let supView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.identifier,
            for: indexPath
        ) as? TrackerCollectionViewHeader {
            supView.configure(with: title)
            return supView
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension TrackersCollectionViewController {
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        contextMenu(for: indexPath)
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        guard let indexPath = indexPaths.first else { return nil }
        return contextMenu(for: indexPath)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfiguration configuration: UIContextMenuConfiguration,
        highlightPreviewForItemAt indexPath: IndexPath
    ) -> UITargetedPreview? {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell {
            return UITargetedPreview(view: cell.cardView)
        } else {
            return nil
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfiguration configuration: UIContextMenuConfiguration,
        dismissalPreviewForItemAt indexPath: IndexPath
    ) -> UITargetedPreview? {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell {
            return UITargetedPreview(view: cell.cardView)
        } else {
            return nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
            
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell {
            return UITargetedPreview(view: cell.cardView)
        } else {
            return nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
            
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell {
            return UITargetedPreview(view: cell.cardView)
        } else {
            return nil
        }
    }
    
    private func contextMenu(for indexPath: IndexPath) -> UIContextMenuConfiguration {
        let isPinned = viewModel.categories[indexPath.section].trackers[indexPath.row].isPinned
        
        let pinAction = UIAction(
            title: isPinned ?
                   L10n.Localizable.CollectionScreen.ContextMenu.unpinAction :
                   L10n.Localizable.CollectionScreen.ContextMenu.pinAction
        )
        { [weak self] _ in
            
            self?.viewModel.pinTracker(at: indexPath)
            
            self?.analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.main.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.pin.rawValue
            ])
        }
        
        let editAction = UIAction(
            title: L10n.Localizable.CollectionScreen.ContextMenu.editAction
        ) { [weak self] _ in
            guard let self = self else { return }
            
            let model = viewModel.fetchTracker(at: indexPath)
            
            let vc = TrackerSetupViewController(
                isTracker: true,
                model: model
            )
            vc.delegate = self
            present(vc,animated: true)
            
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.main.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.edit.rawValue
            ])
        }
        
        let deleteAction = UIAction(
            title: L10n.Localizable.CollectionScreen.ContextMenu.deleteAction,
            attributes: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            
            let alertController = UIAlertController(
                title: nil,
                message: L10n.Localizable.CollectionScreen.AlertController.message,
                preferredStyle: .actionSheet
            )
            let deleteAction = UIAlertAction(
                title: L10n.Localizable.CollectionScreen.AlertController.deleteAction,
                style: .destructive
            ) { [weak self] _ in
                self?.viewModel.deleteTracker(at: indexPath)
            }
            let cancelAction = UIAlertAction(
                title: L10n.Localizable.CollectionScreen.AlertController.cancelAction,
                style: .cancel
            )
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
            
            analyticsService.sendEvent(params: [
                AnalyticsService.Parameters.event.rawValue: AnalyticsService.Event.click.rawValue,
                AnalyticsService.Parameters.screen.rawValue: AnalyticsService.Screen.main.rawValue,
                AnalyticsService.Parameters.item.rawValue: AnalyticsService.Item.delete.rawValue
            ])
        }
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, actionProvider: { _ in
            UIMenu(children: [pinAction, editAction, deleteAction])
        })
    }
}

// MARK: - UICollectionViewFlowLayout

extension TrackersCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.bounds.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: params.leftInset, bottom: 24, right: params.rightInset)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: 0, height: 18)
    }
}

// MARK: - UISearchBarDelegate

extension TrackersCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchFieldDidChanged(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.isEnabled = true
        viewModel.fetchTrackersAtCurrentDate()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        return true
    }
}

// MARK: - TrackersCollectionViewCellDelegate

extension TrackersCollectionViewController: TrackersCollectionViewCellDelegate {
    func addRecord(with recordID: UUID, for trackerID: UUID) {
        viewModel.addRecord(with: recordID, for: trackerID)
    }
    
    func deleteRecord(with recordID: UUID) {
        viewModel.deleteRecord(with: recordID)
    }
}

// MARK: - NewTrackerViewControllerDelegate & TrackerSetupViewControllerDelegate

extension TrackersCollectionViewController: NewTrackerViewControllerDelegate & TrackerSetupViewControllerDelegate {
    func dismiss() {
        dismiss(animated: true)
    }
}



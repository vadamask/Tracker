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
    private let params: GeometricParameters
    private var filter: Filter?
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let placeholder = UIImageView(image: UIImage())
    private let placeholderLabel = UILabel()
    private let filterButton = UIButton(type: .system)
    
    init(params: GeometricParameters) {
        self.params = params
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
        viewModel.fetchTrackersAtCurrentDate()
    }
    
    private func bind() {

        viewModel.$categories.bind { [weak self] categories in
            if categories.isEmpty {
                self?.placeholder.image = UIImage(named: "empty list")
                self?.placeholderLabel.text = L10n.Localizable.CollectionScreen.EmptyState.title
                self?.placeholder.isHidden = false
                self?.placeholderLabel.isHidden = false
                self?.filterButton.isHidden = true
            } else {
                self?.placeholder.isHidden = true
                self?.placeholderLabel.isHidden = true
                self?.filterButton.isHidden = false
            }
            self?.collectionView.reloadData()
        }
        
        viewModel.$searchIsEmpty.bind { [weak self] isEmpty in
            if isEmpty {
                self?.placeholder.image = UIImage(named: "empty search result")
                self?.placeholderLabel.text = L10n.Localizable.CollectionScreen.EmptySearch.title
                self?.placeholder.isHidden = false
                self?.placeholderLabel.isHidden = false
            } else {
                self?.placeholder.isHidden = true
                self?.placeholderLabel.isHidden = true
            }
        }
    }
    
    @objc private func addNewTracker() {
        let vc = NewTrackerViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func datePickerDidChanged(sender: UIDatePicker) {
        viewModel.dateDidChanged(sender.date)
    }
    
    @objc private func filtersDidTapped() {
        let vc = FiltersViewController(filter: filter)
        vc.completion = { [weak self] filter in
            self?.filter = filter
            
            switch filter {
            case .all:
                self?.viewModel.fetchTrackersAtCurrentDate()
            case .today:
                let datePicker = self?.navigationItem.rightBarButtonItem?.customView as? UIDatePicker
                datePicker?.date = Date()
                self?.viewModel.dateDidChanged(Date())
            case .completed:
                self?.viewModel.fetchCompletedTrackers()
            case .incomplete:
                self?.viewModel.fetchIncompleteTrackers()
            }
             
        }
        present(vc, animated: true)
    }
    
    private func setupNavigationItem() {
        
        let leftItem = UIBarButtonItem(
            image: UIImage(named: "add tracker button"),
            style: .plain,
            target: self,
            action: #selector(addNewTracker)
        )
        leftItem.tintColor = .blackYP
        
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerDidChanged(sender:)), for: .valueChanged)
        
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
    }
    
    private func setupViews() {
        
        view.backgroundColor = .whiteYP
        
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = .blackYP
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        filterButton.setTitle(L10n.Localizable.CollectionScreen.filterButton, for: .normal)
        filterButton.backgroundColor = .blueYP
        filterButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        filterButton.setTitleColor(.whiteYP, for: .normal)
        filterButton.layer.cornerRadius = 16
        filterButton.addTarget(self, action: #selector(filtersDidTapped), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .whiteYP
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
        let details = viewModel.detailsFor(tracker)
        
        cell.configure(with: tracker, isDone: details.isDone, completedDays: details.completedDays)
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
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        guard let indexPath = indexPaths.first else { return nil }
        
        let pinAction = UIAction(title: L10n.Localizable.CollectionScreen.ContextMenu.pinAction) { [weak self] _ in
            
        }
        
        let editAction = UIAction(title: L10n.Localizable.CollectionScreen.ContextMenu.editAction) { [weak self] _ in
            let cell = self?.viewModel.categories[indexPath.section].trackers[indexPath.row]
            
        }
        
        let deleteAction = UIAction(title: L10n.Localizable.CollectionScreen.ContextMenu.deleteAction, attributes: .destructive) { [weak self] _ in
            let alertController = UIAlertController(
                title: nil,
                message: L10n.Localizable.CollectionScreen.AlertController.message,
                preferredStyle: .actionSheet
            )
            let deleteAction = UIAlertAction(title: L10n.Localizable.CollectionScreen.AlertController.deleteAction, style: .destructive) { _ in
                self?.viewModel.deleteTracker(at: indexPath)
            }
            let cancelAction = UIAlertAction(title: L10n.Localizable.CollectionScreen.AlertController.cancelAction, style: .cancel)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self?.present(alertController, animated: true)
        }
        
        return UIContextMenuConfiguration(actionProvider: { _ in
            UIMenu(children: [pinAction, editAction, deleteAction])
        })
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
        if searchText.isEmpty {
            viewModel.fetchTrackersAtCurrentDate()
            
        } else {
            viewModel.searchFieldDidChanged(searchText)
        }
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
    
    func willAddRecord(with uuid: UUID) -> Bool {
        viewModel.willAddRecord(with: uuid)
    }
    
    func willDeleteRecord(with uuid: UUID) -> Bool {
        viewModel.willDeleteRecord(with: uuid)
    }
}

extension TrackersCollectionViewController: NewTrackerViewControllerDelegate {
    func dismiss() {
        dismiss(animated: true)
    }
}

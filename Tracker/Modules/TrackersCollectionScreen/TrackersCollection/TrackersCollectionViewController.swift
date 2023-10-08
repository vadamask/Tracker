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
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let placeholder = UIImageView(image: UIImage())
    private let placeholderLabel = UILabel()
    
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
        viewModel.fetchObjectsAtCurrentDate()
    }
    
    private func bind() {

        viewModel.$categories.bind { [weak self] categories in
            if categories.isEmpty {
                self?.placeholder.image = UIImage(named: "empty list")
                self?.placeholderLabel.text = NSLocalizedString("collection.emptyState.title", comment: "Text for empty state on main screen")
                self?.placeholder.isHidden = false
                self?.placeholderLabel.isHidden = false
            } else {
                self?.placeholder.isHidden = true
                self?.placeholderLabel.isHidden = true
            }
            self?.collectionView.reloadData()
        }
        
        viewModel.$searchIsEmpty.bind { [weak self] isEmpty in
            if isEmpty {
                self?.placeholder.image = UIImage(named: "empty search result")
                self?.placeholderLabel.text = NSLocalizedString("collection.emptySearch.title", comment: "Text for empty search")
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
        searchController.searchBar.placeholder = NSLocalizedString(
            "collection.searchBar.placeholder",
            comment: "Placeholder in search bar"
        )
        searchController.searchBar.setValue(
            NSLocalizedString(
                "collection.searchBar.cancelButton",
                comment: "Title for cancel button in search bar"
            ),
            forKey: "cancelButtonText"
        )
        searchController.searchBar.delegate = self
        
        navigationItem.title = NSLocalizedString("collection.navigationTitle", comment: "Title for navigation bar")
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.searchController = searchController
    }
    
    private func setupViews() {
        
        view.backgroundColor = .whiteYP
        
        placeholderLabel.textAlignment = .center
        placeholderLabel.textColor = .blackYP
        placeholderLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .whiteYP
        collectionView.register(TrackersCollectionViewCell.self,
                                forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        collectionView.register(TrackerCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: TrackerCollectionViewHeader.identifier)
    }
    
    private func setupLayout() {
        
        view.addSubview(collectionView)
        
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
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
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

// MARK: - UICollectionViewFlowLayout

extension TrackersCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: params.leftInset, bottom: 24, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: 0, height: 18)
    }
}

// MARK: - UISearchBarDelegate

extension TrackersCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.fetchObjectsAtCurrentDate()
            
        } else {
            viewModel.searchFieldDidChanged(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.isEnabled = true
        viewModel.fetchObjectsAtCurrentDate()
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

//
//  TrackersListViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import SnapKit
import UIKit

final class TrackerCollectionViewController: UIViewController {
    
    private var trackerStore = TrackerStore()
    private let recordStore = TrackerRecordStore()

    private let params: GeometricParameters
    private let placeholder = UIImageView(image: UIImage(named: "empty list"))
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let placeholderLabel = UILabel(
        text: "Что будем отслеживать?",
        textColor: .blackYP,
        font: .systemFont(ofSize: 12, weight: .medium)
    )
    
    private var currentDate = Date() {
        didSet {
            trackerStore.filterTrackers(at: currentDate)
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        return formatter
    }()
    
    private let searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = "Поиск"
        searchField.clearButtonMode = .always
        return searchField
    }()
    
    init(params: GeometricParameters) {
        self.params = params
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteYP
        
        trackerStore.delegate = self
        
        setupNavigationItem()
        setupViews()
        setupLayout()
        checkPlaceholder()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Трекеры"
        
        let leftItem = UIBarButtonItem(
            image: UIImage(named: "add tracker button"),
            style: .plain,
            target: self,
            action: #selector(addNewTracker)
        )
        leftItem.tintColor = .blackYP
        navigationItem.leftBarButtonItem = leftItem
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerDidChanged(sender:)), for: .valueChanged)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func setupViews() {
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
            TrackerCategoryHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCategoryHeader.identifier
        )
        
        placeholderLabel.textAlignment = .center
    }
    
    @objc private func addNewTracker() {
        let typeVC = TrackerTypeViewController()
        typeVC.delegate = self
        present(typeVC, animated: true)
    }
    
    @objc private func datePickerDidChanged(sender: UIDatePicker) {
        currentDate = sender.date
    }
    
    private func checkPlaceholder() {
        if trackerStore.numberOfSections() == 0 && navigationItem.leftBarButtonItem!.isEnabled {
            placeholder.image = UIImage(named: "empty list")
            placeholderLabel.text = "Что будем отслеживать?"
        } else {
            placeholder.image = UIImage(named: "empty search result")
            placeholderLabel.text = "Ничего не найдено"
        }
        placeholder.isHidden = trackerStore.numberOfSections() != 0
        placeholderLabel.isHidden = placeholder.isHidden
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

extension TrackerCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackerStore.numberOfSections() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStore.numberOfItemsIn(section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tracker = trackerStore.cellForItem(at: indexPath) else { return UICollectionViewCell() }
        
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCollectionViewCell.identifier, for: indexPath
        ) as? TrackersCollectionViewCell {
            
            cell.delegate = self
            let date = dateFormatter.string(from: currentDate)
            let details = trackerStore.detailsForCell(indexPath, at: date)
            cell.configure(with: tracker, isDone: details.isDone, completedDays: details.completedDays)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let title = trackerStore.titleForSection(at: indexPath) else { return UICollectionReusableView() }
        if let supView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCategoryHeader.identifier,
            for: indexPath
        ) as? TrackerCategoryHeader {
            supView.configure(with: title)
            return supView
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewFlowLayout

extension TrackerCollectionViewController: UICollectionViewDelegateFlowLayout {
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

extension TrackerCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            trackerStore.filterTrackers(at: currentDate)
        } else {
            trackerStore.searchTrackers(with: searchText, at: currentDate)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.isEnabled = true
        trackerStore.filterTrackers(at: currentDate)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        return true
    }
}

// MARK: - TrackersCollectionViewCellDelegate

extension TrackerCollectionViewController: TrackersCollectionViewCellDelegate {
    func recordWillAdd(with uuid: UUID) -> Bool {
        if currentDate < Date() {
            do {
                try recordStore.addRecord(TrackerRecord(uuid: uuid, date: dateFormatter.string(from: currentDate)))
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        return false
    }
    
    func recordWillRemove(with uuid: UUID) -> Bool {
        do {
            try recordStore.removeRecord(with: uuid, at: dateFormatter.string(from: currentDate))
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
}

// MARK: - TrackerTypeViewControllerDelegate

extension TrackerCollectionViewController: TrackerTypeViewControllerDelegate {
    func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    func didCreate(_ tracker: Tracker, with title: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            do {
                try trackerStore.add(tracker, with: title)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - TrackerStoreDelegate

extension TrackerCollectionViewController: TrackerStoreDelegate {
    func didUpdate(_ trackerStoreUpdate: TrackerStoreUpdate) {
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: trackerStoreUpdate.insertedItems)
            collectionView.deleteItems(at: trackerStoreUpdate.deletedItems)
            collectionView.insertSections(trackerStoreUpdate.insertedSections)
            collectionView.deleteSections(trackerStoreUpdate.deletedSections)
        }
        checkPlaceholder()
    }
    
    func didFetchedObjects() {
        collectionView.reloadData()
        checkPlaceholder()
    }
}

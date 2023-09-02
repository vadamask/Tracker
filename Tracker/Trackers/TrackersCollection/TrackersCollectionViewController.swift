//
//  TrackersListViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import UIKit

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}

final class TrackersCollectionViewController: UIViewController {
    
    private var categories: [TrackerCategory] = [
//        TrackerCategory(title: "Домашние дела", trackers: [Tracker(id: UUID(), name: "Полить цветы", color: "Color selection 0", emoji: "😌", schedule: []),
//                                                           Tracker(id: UUID(), name: "Полить цветы", color: "Color selection 0", emoji: "😌", schedule: [])]),
//        TrackerCategory(title: "Другие дела", trackers: [Tracker(id: UUID(), name: "Полить цветы", color: "Color selection 1", emoji: "😌", schedule: [])])
    ] {
        didSet {
            visibleCategories = categories
        }
    }
    
    private var visibleCategories: [TrackerCategory] = [
//        TrackerCategory(title: "Домашние дела", trackers: [Tracker(id: UUID(), name: "Полить цветы", color: "Color selection 0", emoji: "😌", schedule: []),
//                                                           Tracker(id: UUID(), name: "Полить цветы", color: "Color selection 0", emoji: "😌", schedule: [])]),
//        TrackerCategory(title: "Другие дела", trackers: [Tracker(id: UUID(), name: "Полить цветы", color: "Color selection 1", emoji: "😌", schedule: [])])
    ] {
        didSet {
            collectionView.reloadData()
            checkPlaceholder()
        }
    }
    
    
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date!
    private var params: GeometricParams!
    
    private let placeholder: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty list")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .whiteYP
        return collectionView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .blackYP
        label.textAlignment = .center
        return label
    }()
    
    private let searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholder = "Поиск"
        searchField.clearButtonMode = .always
        return searchField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        checkPlaceholder()
    }
    
    private func setupViews() {
        view.backgroundColor = .whiteYP
        setupNavigationItem()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(
            TrackersCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier
        )
        collectionView.register(
            TrackerCategoryHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCategoryHeader.identifier
        )
        params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Трекеры"
        
        let leftItem = UIBarButtonItem(
            image: UIImage(named: "add tracker button"),
            style: .plain,
            target: self,
            action: #selector(addTracker)
        )
        leftItem.tintColor = .blackYP
        navigationItem.leftBarButtonItem = leftItem
        
        let datePicker = UIDatePicker()
        datePicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = .init(identifier: "Ru_ru")
        currentDate = datePicker.date
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        collectionView.addSubview(placeholder)
        collectionView.addSubview(label)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            placeholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholder.heightAnchor.constraint(equalToConstant: 80),
            placeholder.widthAnchor.constraint(equalToConstant: 80),

            label.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func addTracker() {
        let typeVC = TrackerTypeViewController(delegate: self)
        present(typeVC, animated: true)
    }
    
    private func checkPlaceholder() {
        if categories.isEmpty {
            placeholder.image = UIImage(named: "empty list")
            label.text = "Что будем отслеживать?"
        } else {
            placeholder.image = UIImage(named: "empty search result")
            label.text = "Ничего не найдено"
        }
        placeholder.isHidden = !visibleCategories.isEmpty
        label.isHidden = placeholder.isHidden
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCollectionViewCell.identifier,
            for: indexPath
        ) as? TrackersCollectionViewCell {
            cell.configure(with: visibleCategories[indexPath.section].trackers[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let supView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCategoryHeader.identifier,
            for: indexPath
        ) as? TrackerCategoryHeader {
            supView.configure(with: visibleCategories[indexPath.section])
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

// MARK: - UICollectionViewDelegate

extension TrackersCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // FIXME: убрать отсюда, пока для простоты удаления
        if categories[indexPath.section].trackers.count == 1 {
            categories.remove(at: indexPath.section)
        } else {
            categories[indexPath.section] = TrackerCategory(
                title: categories[indexPath.section].title,
                trackers: categories[indexPath.section].trackers.enumerated().filter { $0.offset != indexPath.row }.map { $0.element }
            )
        }
    }
}

// MARK: - UISearchBarDelegate

extension TrackersCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        visibleCategories = categories
            .filter { $0.trackers
                .contains(where: {
                    $0.name.lowercased().hasPrefix(searchText.lowercased())
                })
            }
        checkPlaceholder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        checkPlaceholder()
        visibleCategories = categories
    }
}

// MARK: - TrackerTypeViewControllerDelegate

extension TrackersCollectionViewController: TrackerTypeViewControllerDelegate {
    func didCreateTrackerWith(_ category: TrackerCategory) {
        if let index = categories.firstIndex(where: { $0.title == category.title }) {
            categories[index] = TrackerCategory(title: category.title, trackers: categories[index].trackers + category.trackers)
        } else {
            categories.append(category)
        }
        dismiss(animated: true)
    }
}

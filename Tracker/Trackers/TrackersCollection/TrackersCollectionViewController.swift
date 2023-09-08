//
//  TrackersListViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import UIKit

final class TrackersCollectionViewController: UIViewController {
    
    private var categories: [TrackerCategory] = [] {
        didSet {
            filterRelevantTrackers()
        }
    }
    
    private var visibleCategories: [TrackerCategory] = [] {
        didSet {
            collectionView.reloadData()
            checkPlaceholder()
        }
    }
    
    private var currentDate: Date! {
        didSet {
            filterRelevantTrackers()
        }
    }
    
    private var visibleCategoriesAtSpecificDay: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private let params: GeometricParameters
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        return formatter
    }()
    
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
        setupNavigationItem()
        setupCollectionView()
        setupConstraints()
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
        datePicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerDidChanged(sender:)), for: .valueChanged)
        currentDate = datePicker.date
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
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
    
    @objc private func addNewTracker() {
        let typeVC = TrackerTypeViewController(delegate: self)
        present(typeVC, animated: true)
    }
    
    @objc private func datePickerDidChanged(sender: UIDatePicker) {
        currentDate = sender.date
    }
    
    private func checkPlaceholder() {
        if categories.isEmpty || visibleCategoriesAtSpecificDay.isEmpty {
            placeholder.image = UIImage(named: "empty list")
            label.text = "Что будем отслеживать?"
        } else {
            placeholder.image = UIImage(named: "empty search result")
            label.text = "Ничего не найдено"
        }
        placeholder.isHidden = !visibleCategories.isEmpty
        label.isHidden = placeholder.isHidden
    }
    
    private func filterRelevantTrackers() {
        var weekday = Calendar(identifier: .gregorian).component(.weekday, from: currentDate)
        weekday = weekday == 1 ? 6 : (weekday - 2)
                
        if let day = WeekDay(rawValue: weekday) {
            
            let relevantCategories = categories
                .filter { $0.trackers.contains(where: { $0.schedule.contains(day)})}
            
            let relevantTrackers = relevantCategories
                .map { $0.trackers.filter {$0.schedule.contains(day)}}
            
            var result: [TrackerCategory] = []
            
            for i in 0..<relevantCategories.count {
                result.append(TrackerCategory(title: relevantCategories[i].title, trackers: relevantTrackers[i]))
            }
            self.visibleCategoriesAtSpecificDay = result
            self.visibleCategories = result
        }
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
            withReuseIdentifier: TrackersCollectionViewCell.identifier, for: indexPath
        ) as? TrackersCollectionViewCell {
            
            cell.delegate = self
            let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
            
            let isDone = completedTrackers.contains(where: {
                        $0.id == tracker.id && dateFormatter.string(from: $0.date) == dateFormatter.string(from: currentDate)})
            
            let completedDays = completedTrackers.filter({ $0.id == tracker.id }).count
            
            cell.configure(with: tracker, isDone: isDone, completedDays: completedDays)
            
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

// MARK: - UISearchBarDelegate

extension TrackersCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        visibleCategories = visibleCategoriesAtSpecificDay
            .filter { $0.trackers
                .contains(where: {
                    $0.name.lowercased().hasPrefix(searchText.lowercased())
                })
            }
        checkPlaceholder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        checkPlaceholder()
        visibleCategories = visibleCategoriesAtSpecificDay
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        return true
    }
}

// MARK: - TrackerTypeViewControllerDelegate

extension TrackersCollectionViewController: TrackerTypeViewControllerDelegate {
    func didCreateTrackerWith(_ category: TrackerCategory) {
        if let index = categories.firstIndex(where: { $0.title == category.title }) {
            categories[index] = TrackerCategory(
                title: category.title,
                trackers: (categories[index].trackers + category.trackers)
            )
        } else {
            categories.append(category)
        }
        dismiss(animated: true)
    }
}

// MARK: - TrackersCollectionViewCellDelegate

extension TrackersCollectionViewController: TrackersCollectionViewCellDelegate {
    func recordWillAdd(with id: UUID) -> Bool {
        if currentDate < Date() {
            completedTrackers.insert(TrackerRecord(id: id, date: currentDate))
            return true
        }
        return false
    }
    
    func recordWillRemove(with id: UUID) -> Bool {
        if let index = completedTrackers.firstIndex(where: {
            $0.id == id && dateFormatter.string(from: $0.date) == dateFormatter.string(from: currentDate)}) {
            completedTrackers.remove(at: index)
            return true
        }
        return false
    }
}

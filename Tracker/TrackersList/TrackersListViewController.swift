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

final class TrackersListViewController: UIViewController {
    
    private var trackers = [
        Tracker(id: UUID(), name: "Поливать растения", color: "Color selection 5", emoji: "😀", schedule: 0),
        Tracker(id: UUID(), name: "Чистить зубы", color: "Color selection 6", emoji: "😇", schedule: 1),
        Tracker(id: UUID(), name: "Пить воду", color: "Color selection 7", emoji: "🤪", schedule: 2),
        Tracker(id: UUID(), name: "Делать зарядку", color: "Color selection 8", emoji: "😗", schedule: 3)
    ] {
        didSet {
            checkImageView()
        }
    }
    
    private var params: GeometricParams!
    
    private let imageView: UIImageView = {
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
        setupNavigationItem()
        setupConstraints()
        setupCollectionView()
        view.backgroundColor = .whiteYP
        checkImageView()
        searchField.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
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
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = .init(identifier: "Ru_ru")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(searchField)
        collectionView.addSubview(imageView)
        collectionView.addSubview(label)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            imageView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func addTracker() {
        let forkVC = TrackerTypeViewController()
        present(forkVC, animated: true)
    }
    
    private func checkImageView() {
        imageView.isHidden = trackers.isEmpty ? false : true
        label.isHidden = imageView.isHidden
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.identifier, for: indexPath) as? TrackersCollectionViewCell {
            cell.configure(with: trackers[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewFlowLayout

extension TrackersListViewController: UICollectionViewDelegateFlowLayout {
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
}

// MARK: - UISearchBarDelegate

extension TrackersListViewController: UITextFieldDelegate {
    
}

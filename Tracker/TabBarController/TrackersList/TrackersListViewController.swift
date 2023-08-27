//
//  TrackersListViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 27.08.2023.
//

import UIKit

final class TrackersListViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty list")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupConstraints()
        view.backgroundColor = .whiteYP
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Трекеры"
        
        let leftItem = UIBarButtonItem(
            image: UIImage(named: "plus"),
            style: .plain,
            target: self,
            action: #selector(addTracker)
        )
        
        leftItem.tintColor = .blackYP
        navigationItem.leftBarButtonItem = leftItem
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        
        let rightItem = UIBarButtonItem(customView: datePicker)
        
        navigationItem.rightBarButtonItem = rightItem
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func addTracker() {
        
    }
}


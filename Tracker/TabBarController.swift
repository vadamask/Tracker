//
//  ViewController.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.08.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let trackersVC = TrackersCollectionView(params: GeometricParameters(
            cellCount: 2,
            leftInset: 16,
            rightInset: 16,
            cellSpacing: 9)
        )
        let statisticsVC = StatisticsViewController()
        let trackersNavigationVC = UINavigationController(rootViewController: trackersVC)
        let statisticsNavigationVC = UINavigationController(rootViewController: statisticsVC)
        trackersNavigationVC.navigationBar.prefersLargeTitles = true
        statisticsNavigationVC.navigationBar.prefersLargeTitles = true
        
        trackersVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(imageLiteralResourceName: "trackersItem"),
            selectedImage: nil
        )
        
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(imageLiteralResourceName: "statsItem"),
            selectedImage: nil
        )
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .whiteYP
        tabBar.standardAppearance = appearance
        if #available(iOS 15, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        tabBar.tintColor = .blueYP
        tabBar.unselectedItemTintColor = .grayYP
        
        self.viewControllers = [trackersNavigationVC, statisticsNavigationVC]
    }
}


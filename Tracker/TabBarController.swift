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
    private let colors = Colors.shared
    
    private func setupTabBar() {
        let trackersVC = TrackersCollectionViewController(params: GeometricParameters(
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
            title: L10n.Localizable.TabBarItem.collection,
            image: UIImage(imageLiteralResourceName: "trackersItem"),
            selectedImage: nil
        )
        
        statisticsVC.tabBarItem = UITabBarItem(
            title: L10n.Localizable.TabBarItem.statistics,
            image: UIImage(imageLiteralResourceName: "statsItem"),
            selectedImage: nil
        )
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = colors.whiteDynamicYP
        tabBar.standardAppearance = appearance
        if #available(iOS 15, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        tabBar.tintColor = colors.blueStaticYP
        tabBar.unselectedItemTintColor = colors.grayStaticYP
        
        self.viewControllers = [trackersNavigationVC, statisticsNavigationVC]
    }
}


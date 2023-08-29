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
        let trackersVC = TrackersListViewController()
        let statisticsVC = StatisticsViewController()
        let navigationVC = UINavigationController(rootViewController: trackersVC)
        navigationVC.navigationBar.prefersLargeTitles = true
        
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
        
        self.viewControllers = [navigationVC, statisticsVC]
    }
}


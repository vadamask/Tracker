//
//  AppDelegate.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.08.2023.
//

import YandexMobileMetrica
import CoreData
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = onboardingDidVisited ? TabBarController() : OnboardingViewController()
        window?.makeKeyAndVisible()
        
        if let configuration = YMMYandexMetricaConfiguration(apiKey: "ea508846-9cf1-4216-9f06-cc378ace94a0") {
            YMMYandexMetrica.activate(with: configuration)
        }
        return true
    }
    
    private var onboardingDidVisited: Bool {
        get {
            UserDefaults.standard.bool(forKey: "onboardingDidVisited")
        }
    }
}


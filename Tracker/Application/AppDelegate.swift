//
//  AppDelegate.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.08.2023.
//

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
        return true
    }
    
    private var onboardingDidVisited: Bool {
        get {
            UserDefaults.standard.bool(forKey: "onboardingDidVisited")
        }
    }
}


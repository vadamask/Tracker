//
//  AppDelegate.swift
//  Tracker
//
//  Created by Вадим Шишков on 24.08.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = TabBarController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}


//
//  AppDelegate.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppViewController()
        window?.makeKeyAndVisible()
        return true
    }
}


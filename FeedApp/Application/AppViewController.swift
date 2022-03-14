//
//  AppViewController.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import UIKit

class AppViewController: UIViewController {
    
    private let authService = ServiceLayer.shared.authService

    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedCode = authService.code {
            showFeedScreen(code: savedCode)
        } else {
            showLoginScreen()
        }
    }
    
    private func showLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        add(loginVC)
    }
    
    private func showFeedScreen(code: Code) {
        let feedVC = FeedViewController(code: code)
        feedVC.delegate = self
        let navController = UINavigationController(rootViewController: feedVC)
        add(navController)
    }
}

extension AppViewController: LoginViewControllerDelegate {
    func loginViewControllerDidAuth(_ viewController: LoginViewController, code: Code) {
        showFeedScreen(code: code)
        viewController.remove()
    }
}

extension AppViewController: FeedViewControllerDelegate {
    func feedViewControllerDidLogOut(_ viewController: FeedViewController) {
        showLoginScreen()
        viewController.remove()
        authService.logout()
    }
}

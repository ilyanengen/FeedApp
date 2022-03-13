//
//  AppViewController.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import UIKit

class AppViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        // TODO:
        var isSignedIn = false
        
        if isSignedIn == true {
            showFeedScreen()
        } else {
            showLoginScreen()
        }
    }
    
    private func showLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        add(loginVC)
    }
    
    private func showFeedScreen() {
        let feedVC = FeedViewController()
        feedVC.delegate = self
        let navController = UINavigationController(rootViewController: feedVC)
        add(navController)
    }
}

extension AppViewController: LoginViewControllerDelegate {
    func loginViewControllerDidAuth(_ viewController: LoginViewController, code: Code) {
        showFeedScreen()
        viewController.remove()
    }
}

extension AppViewController: FeedViewControllerDelegate {
    func feedViewControllerDidLogOut(_ viewController: FeedViewController) {
        showLoginScreen()
        viewController.remove()
    }
}

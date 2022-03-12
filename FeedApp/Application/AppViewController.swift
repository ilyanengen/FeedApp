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
            showMain()
        } else {
            showLogin()
        }
    }
    
    private func showLogin() {
        let loginVC = LoginViewController()
        add(loginVC)
    }
    
    private func showMain() {
        // TODO
    }
}

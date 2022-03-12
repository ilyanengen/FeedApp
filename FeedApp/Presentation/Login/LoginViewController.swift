//
//  LoginViewController.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonDidTap(_ sender: UIButton) {
    }
}

extension LoginViewController: UITextFieldDelegate {
    
}

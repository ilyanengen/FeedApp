//
//  LoginViewController.swift
//  FeedApp
//
//  Created by Илья Билтуев on 12.03.2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    private let authService = ServiceLayer.shared.authService
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonDidTap(_ sender: UIButton) {
        // TODO: validate textfields here
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text
        else {
            return
        }
        authService.signIn(
            username: username,
            password: password
        ) { [weak self] error in
            DispatchQueue.main.async {
                print(error)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
}

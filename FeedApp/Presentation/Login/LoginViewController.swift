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
        startObservingKeyboard()
        addKeyboardHideTapRecognizer()
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
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let code):
                    print(code)
                }
            }
        }
    }
    
    // MARK: - Keyboard
    
    private func addKeyboardHideTapRecognizer() {
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapOnView.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnView)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func startObservingKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        scrollView.contentInset = contentInsets
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @objc private func handleKeyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

extension LoginViewController: UITextFieldDelegate {
    // TODO
}

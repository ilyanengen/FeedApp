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
    
    weak var delegate: LoginViewControllerDelegate?
    
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
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.showErrorAlert(error: error)
                case .success(let code):
                    self.delegate?.loginViewControllerDidAuth(self, code: code)
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
        let newBottomInset = keyboardFrame.size.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: newBottomInset, right: 0)
        scrollView.contentInset = contentInsets
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @objc private func handleKeyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

extension LoginViewController: UITextFieldDelegate {
    // TODO
}

protocol LoginViewControllerDelegate: AnyObject {
    func loginViewControllerDidAuth(_ viewController: LoginViewController, code: Code)
}

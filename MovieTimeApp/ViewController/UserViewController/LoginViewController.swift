//
//  LoginViewController.swift
//  MovieApp
//
//  Created by Caner Karabulut on 15.01.2024.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    //MARK: - Properties
    private var viewModel = LogInViewModel()
    
    private let logoImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .purple
        imageView.image = UIImage(named: "movieLogo")
        return imageView
    }()
    private lazy var emailContainerView: UIView = {
        let containerView = AuthInputView(image: UIImage(systemName: "envelope.fill")!, textField: emailTextField)
        return containerView
    }()
    private lazy var passwordContainerView: UIView = {
        let containerView = AuthInputView(image: UIImage(systemName: "lock.fill")!, textField: passwordTextField)
        containerView.addSubview(hideAndShowButton)
        NSLayoutConstraint.activate([
            hideAndShowButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            hideAndShowButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            hideAndShowButton.widthAnchor.constraint(equalToConstant: 24),
            hideAndShowButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        hideAndShowButton.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    private let emailTextField: UITextField = {
        let textField = CustomTextField(placeHolder: "Email")
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = CustomTextField(placeHolder: "Password")
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        return textField
    }()
    private lazy var loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.layer.cornerRadius = 7
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        return button
    }()
    private var stackView = UIStackView()
    
    private lazy var goRegisterationPage: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Click To Become A Member", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 14)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleGoRegister), for: .touchUpInside)
        return button
    }()
    private lazy var hideAndShowButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleHideAndShowButton), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}
//MARK: - Selector
extension LoginViewController {
    @objc private func handleLoginButton(_ sender: UIButton) {
        let loadingAlert = AlertManager.showLoadingAlert(on: self)

        guard let emailText = emailTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        showHud(show: true)
        AuthService.login(emailText: emailText, passwordText: passwordText) { result, error in
            loadingAlert.dismiss(animated: true) {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    AlertManager.showAlert(on: self, title: "Error", message: "Login failed. Please check your credentials and try again.") {
                        self.showHud(show: false)
                    }
                    return
                }
                // Başarılı giriş durumunda yapılacak işlemler
                self.showHud(show: true)
                self.dismiss(animated: true)
            }
        }
    }
    @objc private func handleHideAndShowButton(_ sender: UIButton) {
        hideAndShowButtonConfiguration(textField: passwordTextField, button: hideAndShowButton)
    }
    @objc private func handleGoRegister(_ sender: UIButton) {
        let controller = RegisterViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc private func handleTextField(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.emailText = sender.text
        } else {
            viewModel.passwordText = sender.text
        }
        loginButtonStatus()
    }
}
//MARK: - Helpers
extension LoginViewController {
    private func loginButtonStatus() {
        if viewModel.status {
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    private func style() {
        backgroundGradientColor()
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.layer.cornerRadius = 240 / 2
        
        stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        goRegisterationPage.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        
    }
    private func layout() {
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        view.addSubview(goRegisterationPage)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 240),
            logoImageView.heightAnchor.constraint(equalToConstant: 240),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 32),
            
            goRegisterationPage.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            goRegisterationPage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            view.trailingAnchor.constraint(equalTo: goRegisterationPage.trailingAnchor, constant: 32)
        ])
    }
}

//
//  LoginViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    
    // MARK: - Properties
    
    var authController = AuthorizationController()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    // MARK: - Functions
    
    private func setupViews() {
        self.title = "Log In"
        
        view.backgroundColor = .systemBackground
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
        loginButton.setTitleColor(.systemBlue, for: .normal)
        
        /// Email and password are for testing purposes
        emailTextField.text = "bob_johnson@lambdaschool.com"
        passwordTextField.text = "Testing123!"
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
    }
    
    @objc private func login(_ sender: UIButton) {
        guard let username = emailTextField.text, let password = passwordTextField.text else { return }
        
        authController.logIn(username: username, password: password) { result in
            if let result = try? result.get(),
                let token = result.first as? String,
                let user = result.last as? User {
                /* Do something with the user? If user is super-admin show problems ViewController first
                 if it's not show camera ViewController? */
                DispatchQueue.main.async {
                    let clientsViewController = ClientsViewController()
                    let navigationController = UINavigationController(rootViewController: clientsViewController)
                    clientsViewController.token = token
                    clientsViewController.user = user
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // TODO: Add password recoveryViewController
    
    @objc private func gotToRecoveryViewController() {
        
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48.0),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8.0),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16.0),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            loginButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


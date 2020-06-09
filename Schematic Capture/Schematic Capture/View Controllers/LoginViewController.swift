//
//  LoginViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SwiftyDropbox
import AVFoundation

class LoginViewController: UIViewController {
    
    // MARK: - UI Elements
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let label = UILabel()
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    // MARK: - Properties
    
    var authController = AuthorizationController()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
        paused = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
        paused = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    // MARK: - Functions
    
    private func setupViews() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = .clear
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome To Schematic Capture"
        label.font = .systemFont(ofSize: 35)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .lightText
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.borderStyle = .roundedRect
        emailTextField.alpha = 0.6
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.alpha = 0.6
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Log In", for: .normal)
        loginButton.addTarget(self, action: #selector(login(_:)), for: .touchUpInside)
        loginButton.setTitleColor(.systemBlue, for: .normal)
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.setTitleColor(.systemRed, for: .normal)
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.alpha = 0.7
        
        /// Email and password are for testing purposes
        emailTextField.text = "bob_johnson@lambdaschool.com"
        passwordTextField.text = "Testing123!"
        
        view.addSubview(label)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        //let theURL = Bundle.main.url(forResource:"LoginVideo/", withExtension: "mp4")
        let bundle = Bundle.main
        let path = bundle.path(forResource: "LoginVideo", ofType: "mp4")!
        let theURL = URL.init(fileURLWithPath: path)
        
        player = AVPlayer(url: theURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        player.volume = 0
        player.actionAtItemEnd = .none
        
        playerLayer.frame = view.layer.bounds
        view.layer.insertSublayer(playerLayer, at: 0)
        let shadowView = UIView(frame: view.bounds)
        shadowView.backgroundColor = .black
        shadowView.alpha = 0.95
        view.insertSubview(shadowView, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
    }
    
    @objc private func login(_ sender: UIButton) {
        guard let username = emailTextField.text, let password = passwordTextField.text else { return }
        
        
        authController.logIn(username: username, password: password, viewController: self) { result in
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
            
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48.0),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64),
            //label.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 32.0),
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
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let playerItem: AVPlayerItem = notification.object as! AVPlayerItem
        playerItem.seek(to: .zero, completionHandler: nil)
    }
}


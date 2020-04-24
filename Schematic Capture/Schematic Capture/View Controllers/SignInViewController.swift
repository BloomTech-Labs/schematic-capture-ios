//
//  SignInViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/24/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//
//
import UIKit
import Firebase
import FirebaseStorage
import GoogleSignIn
import SCLAlertView
import WebKit

class SignInViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
   let loginController = LogInController()
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()


        setUpUI()


        }
    

    func setUpUI() {
        
        Style.styleFilledButton(loginButton)

        self.navigationController?.view.backgroundColor = .clear

        loginImage.image = UIImage(imageLiteralResourceName: "OnBoardImage.jpeg")

        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.uiDelegate = self
        if let url = Bundle.main.url(forResource: "Pulse-1s-200px", withExtension: "svg") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }



    func startLoadingScreen() {
        guard let webView = webView else { return }

        DispatchQueue.main.async {
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.backgroundColor = .clear
            webView.isOpaque = false
            self.view.addSubview(webView)

            webView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
            webView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
            webView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            webView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -15).isActive = true
        }
    }

    func stopLoadingScreen() {
        guard let webView = webView else { return }

        DispatchQueue.main.async {
            webView.removeFromSuperview()
            self.webView = nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
         if segue.identifier == "LoginSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.loginController = loginController
            }
        } else if segue.identifier == "HomeVCSegue" {
            if let homeVC = segue.destination as? HomeViewController {
                homeVC.loginController = loginController
                homeVC.projectController.user = loginController.user
                homeVC.projectController.bearer = loginController.bearer
            }
       
        }
    }
}


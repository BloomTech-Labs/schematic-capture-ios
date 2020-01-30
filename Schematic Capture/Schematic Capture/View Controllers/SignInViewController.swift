//
//  SignInViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/24/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SCLAlertView

class SignInViewController: UIViewController {
    
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let loginController = LogInController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        // check network connection
        if Reachability.isConnectedToNetwork() {
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
        } else {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("OK") {
                self.performSegue(withIdentifier: "HomeVCSegue", sender: nil)
            }
            alert.showWarning("No Internet Connection!", subTitle: "Unable to download or upload")
        }
    }

    func setUpUI() {
        Style.styleFilledButton(signUpButton)
        Style.styleHollowButton(loginButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpSegue" {
            if let signUpVC = segue.destination as? SignUpViewController {
                signUpVC.loginController = loginController
            }
        } else if segue.identifier == "LoginSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.loginController = loginController
            }
        } else if segue.identifier == "HomeVCSegue" {
            if let homeVC = segue.destination as? HomeViewController {
                homeVC.loginController = loginController
            }
        }
    }

}


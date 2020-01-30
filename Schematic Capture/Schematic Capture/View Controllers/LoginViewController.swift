//
//  LoginViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SCLAlertView

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var loginController: LogInController?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        // TESTING
        emailTextField.text = "bob_johnson@lambdaschool.com"
        passwordTextField.text = "testing123!"
    }
    func setUpUI() {
        Style.styleTextField(emailTextField)
        Style.styleTextField(passwordTextField)
        Style.styleFilledButton(loginButton)
        errorMessageLabel.alpha = 0
    }
    
    
    @IBAction func login(_ sender: Any) {
        if let error = validateTextFields() {
            errorMessageLabel.alpha = 1
            errorMessageLabel.text = error
            return
        }
        
        guard let loginController = loginController else {
            NSLog("LoginController not found")
            return
        }
        
        let user = User(email: emailTextField.text!, password: passwordTextField.text!)
        
        loginController.logIn(with: user) { (error) in
            if let error = error {
                NSLog("\(error)")
                return
            }
            
            DispatchQueue.main.async {
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("Proceed to main page") {
                    self.performSegue(withIdentifier: "MainPageSegue", sender: nil)
                }
                alert.showSuccess("Login Success!", subTitle: "")
            }
            
        }
    }
    
    func validateTextFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        return nil
    }
}

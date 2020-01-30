//
//  SignUpViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    @IBOutlet weak var tokenTextFIeld: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    var loginController: LogInController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    func setUpUI() {
        Style.styleTextField(firstNameTextField)
        Style.styleTextField(lastNameTextField)
        Style.styleTextField(emailTextField)
        Style.styleTextField(phoneTextField)
        Style.styleTextField(passwordTextField)
        Style.styleTextField(passwordVerificationTextField)
        Style.styleTextField(tokenTextFIeld)
        Style.styleFilledButton(signUpButton)
        errorMessageLabel.alpha = 0
    }
    
    @IBAction func signUp(_ sender: Any) {
        let error = validateTextFields()
        
        if error != nil {
            errorMessageLabel.alpha = 1
            errorMessageLabel.text = error
        }
        
        guard let loginController = loginController else {
            NSLog("LoginController not found")
            return
        }
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let phone = phoneTextField.text!
        let inviteToken = tokenTextFIeld.text!
        
        let user = User(email: email, password: password, firstName: firstName, lastName: lastName, phone: phone, inviteToken: inviteToken)
        
        loginController.logIn(with: user) { (error) in
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            
            print("User sign up successful!")
        }
        
    }
    
    func validateTextFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordVerificationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tokenTextFIeld.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        if !isValidEmail(emailTextField.text!) {
            return "Please enter a valid email."
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password2 = passwordVerificationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if password.count < 8 {
            return "Password must be atleast 8 characters long."
        }
        
        if password != password2 {
            return "Password verification does not match."
        }
        
        return nil
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}

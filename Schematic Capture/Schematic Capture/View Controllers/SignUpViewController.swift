//
//  SignUpViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SCLAlertView

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var tokenTextFIeld: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    var loginController: LogInController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        // TESTING
        firstNameTextField.text = "John"
        lastNameTextField.text = "Kim"
        emailTextField.text = "john@lambda.com"
        phoneTextField.text = "1231231234"
        passwordTextField.text = "testing123!"
        confirmPasswordTextField.text = "testing123!"
        tokenTextFIeld.text = ""
    }
    
    func setUpUI() {
        Style.styleTextField(firstNameTextField)
        Style.styleTextField(lastNameTextField)
        Style.styleTextField(emailTextField)
        Style.styleTextField(phoneTextField)
        Style.styleTextField(passwordTextField)
        Style.styleTextField(confirmPasswordTextField)
        Style.styleTextField(tokenTextFIeld)
        Style.styleFilledButton(signUpButton)
        errorMessageLabel.alpha = 0
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let error = validateTextFields() {
            errorMessageLabel.alpha = 1
            errorMessageLabel.text = error
            return
        }
        
        guard let loginController = loginController else {
            NSLog("LoginController not found")
            return
        }
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let phone = phoneTextField.text!
        let inviteToken = tokenTextFIeld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let user = User(email: email, password: password, confirmPassword: confirmPassword, firstName: firstName, lastName: lastName, phone: phone, inviteToken: inviteToken)
        
        loginController.signUp(with: user) { (error) in
            if let error = error {
                NSLog("Error: \(error)")
                
                let errorMessage = "\(error)"
                guard let firstIndex = errorMessage.lastIndex(of: ":"),
                    let lastIndex = errorMessage.lastIndex(of: "\\") else { return }
                
                let subString = errorMessage[firstIndex..<lastIndex]
                let startIndex = subString.index(subString.startIndex, offsetBy: 3)
                let result = subString[startIndex..<subString.endIndex]
                
                DispatchQueue.main.async {
                    self.errorMessageLabel.text = String(result)
                    self.errorMessageLabel.alpha = 1
                }
                return
            }
            
            DispatchQueue.main.async {
                self.errorMessageLabel.alpha = 0
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("Proceed to main page") {
                    self.performSegue(withIdentifier: "MainPageSegue", sender: nil)
                }
                alert.showSuccess("Congratulations", subTitle: "You have successfully signed up")
            }

        }
    }
    
    func validateTextFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tokenTextFIeld.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        if !isValidEmail(emailTextField.text!) {
            return "Please enter a valid email."
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password2 = confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainPageSegue" {
            if let homeVC = segue.destination as? HomeViewController {
                homeVC.loginController = loginController
            }
        }
    }

}

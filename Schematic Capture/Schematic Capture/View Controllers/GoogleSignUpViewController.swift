//
//  GoogleSignUpViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/31/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SCLAlertView

class GoogleSignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var inviteTokenTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    var loginController: LogInController?
    var accessToken: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTextFieldDelegate()
        setUpUI()
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let error = validateTextFields() {
            errorMessageLabel.alpha = 1
            errorMessageLabel.text = error
            return
        }
        
        guard let loginController = loginController,
            var googleUser = loginController.user else {
            NSLog("Invalid login controller or invalid user")
            return
        }
        
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let phone = phoneTextField.text!
        let inviteToken = inviteTokenTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        googleUser.firstName = firstName
        googleUser.lastName = lastName
        googleUser.phone = phone
        googleUser.inviteToken = inviteToken
        
        loginController.signUp(with: googleUser) { (error) in
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
    
    func setUpUI() {
        Style.styleTextField(firstNameTextField)
        Style.styleTextField(lastNameTextField)
        Style.styleTextField(phoneTextField)
        Style.styleTextField(inviteTokenTextField)
        Style.styleFilledButton(signUpButton)
        errorMessageLabel.alpha = 0
        
        guard let loginController = loginController else { return }
        firstNameTextField.text = loginController.user?.firstName
        lastNameTextField.text = loginController.user?.lastName
    }
    
    func setUpTextFieldDelegate() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneTextField.delegate = self
        inviteTokenTextField.delegate = self
    }
    
    func validateTextFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            inviteTokenTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        return nil
    }

}

extension GoogleSignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

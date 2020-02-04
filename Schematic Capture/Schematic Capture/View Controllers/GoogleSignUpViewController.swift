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
    @IBOutlet weak var baseConstraint: NSLayoutConstraint!
    
    var loginController: LogInController?
    var accessToken: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTextFieldDelegate()
        setUpUI()
        addTapGesture()
        addKeyboardNotification()

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
    
    // Dismiss Keyboard
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func animateWithKeyboard(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let moveUp = (notification.name == UIResponder.keyboardWillShowNotification)
        
        let viewHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
        var displacement: CGFloat = 0
        
        if let textField = getActiveTextField() {
            displacement = viewHeight - (textField.frame.origin.y + keyboardHeight + 15)
        }
        
        baseConstraint.constant = moveUp ? displacement : 40
        
        let options = UIView.AnimationOptions(rawValue: curve << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
    
    func getActiveTextField() -> UITextField? {
        if firstNameTextField.isFirstResponder {
            return firstNameTextField
        } else if lastNameTextField.isFirstResponder {
            return lastNameTextField
        } else if phoneTextField.isFirstResponder {
            return phoneTextField
        } else if inviteTokenTextField.isFirstResponder {
            return inviteTokenTextField
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

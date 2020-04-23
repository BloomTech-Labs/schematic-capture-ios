//
//  LoginViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SCLAlertView
import WebKit

class LoginViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var baseConstraint: NSLayoutConstraint!
    
    var loginController: LogInController?
    var webView: WKWebView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTextFieldDelegate()
        setUpUI()
        addTapGesture()
        addKeyboardNotification()
        
        emailTextField.text = "bob_johnson@lambdaschool.com"
        passwordTextField.text = "Testing123!"
        
    }
    
    func setUpUI() {
        Style.styleTextField(emailTextField)
        Style.styleTextField(passwordTextField)
        Style.styleFilledButton(loginButton)
        errorMessageLabel.alpha = 0
        
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.uiDelegate = self
        if let url = Bundle.main.url(forResource: "Pulse-1s-200px", withExtension: "svg") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }
    
    func setUpTextFieldDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
    
    @IBAction func login(_ sender: Any) {
        startLoadingScreen()
        
        if let error = validateTextFields() {
            errorMessageLabel.alpha = 1
            errorMessageLabel.text = error
            stopLoadingScreen()
            return
        }
        
        guard let loginController = loginController else {
            NSLog("LoginController not found")
            stopLoadingScreen()
            return
        }
        
        let user = User(password: passwordTextField.text!, username: emailTextField.text!)
        
        
        loginController.logIn(username: user.username!, password: user.password!, completion:  { (error) in
            self.stopLoadingScreen()
            
            if let error = error {
                NSLog("\(error)")
                return
            }
            
            DispatchQueue.main.async {
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("Proceed to main page") {
                    self.performSegue(withIdentifier: "HomeVCSegue", sender: nil)
                }
                alert.showSuccess("Login Success!", subTitle: "")
            }
            
        } )
    }
    
    func validateTextFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
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
        if emailTextField.isFirstResponder {
            return emailTextField
        } else if passwordTextField.isFirstResponder {
            return passwordTextField
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeVCSegue" {
            if let homeVC = segue.destination as? HomeViewController {
                homeVC.loginController = loginController
                homeVC.projectController.user = loginController?.user
                homeVC.projectController.bearer = loginController?.bearer
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}


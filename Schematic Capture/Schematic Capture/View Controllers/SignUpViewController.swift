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
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    @IBOutlet weak var tokenTextFIeld: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    func setUpUI() {
        Style.styleTextField(firstNameTextField)
        Style.styleTextField(lastNameTextField)
        Style.styleTextField(emailTextField)
        Style.styleTextField(phoneNumberTextField)
        Style.styleTextField(passwordTextField)
        Style.styleTextField(passwordVerificationTextField)
        Style.styleTextField(tokenTextFIeld)
        Style.styleFilledButton(signUpButton)
        errorMessageLabel.alpha = 0
    }
    
    @IBAction func signUp(_ sender: Any) {
        
    }
    
    

}

//
//  LoginViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    func setUpUI() {
        Style.styleTextField(emailTextField)
        Style.styleTextField(passwordTextField)
        Style.styleFilledButton(loginButton)
        errorMessageLabel.alpha = 0
    }
    
    
    @IBAction func login(_ sender: Any) {
    }
    
}

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

class SignInViewController: UIViewController {
    
    @IBOutlet weak var appLogo: UIImageView!
    
    let userDefault = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // check network connection
        if Reachability.isConnectedToNetwork() {
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
        } else {
            
        }
        
        
    }


    @IBAction func signIn(_ sender: Any) {
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


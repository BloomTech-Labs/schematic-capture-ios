//
//  SignInViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/24/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SignInViewController: UIViewController {
    
    @IBOutlet weak var appLogo: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().signIn()
        
        // check network connection
        
        showFirebaseUISignIn()
    }

    @IBAction func signIn(_ sender: Any) {
        showFirebaseUISignIn()
    }
    
    private func showFirebaseUISignIn() {
        let authUI = FUIAuth.defaultAuthUI()
        let authViewController = authUI!.authViewController()
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true, completion: nil)
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


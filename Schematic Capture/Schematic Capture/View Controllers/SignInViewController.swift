//
//  SignInViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/24/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import FirebaseUI

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        let providers: [FUIAuthProvider] = [FUIGoogleAuth(), FUIEmailAuth()]
        authUI?.providers = providers
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

extension SignInViewController: FUIAuthDelegate {
}

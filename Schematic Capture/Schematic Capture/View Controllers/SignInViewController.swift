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
import SCLAlertView

class SignInViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let loginController = LogInController()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setUpUI()
        
        // check network connection
        if Reachability.isConnectedToNetwork() {
            // if wifi/data is available, setup Google sign in
            GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
        } else {
            // if wifi/data is NOT available, skip the login page and direct to the main page
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("OK") {
                self.performSegue(withIdentifier: "HomeVCSegue", sender: nil)
            }
            alert.showWarning("No Internet Connection!", subTitle: "Unable to download or upload")
        }
    }

    func setUpUI() {
        Style.styleFilledButton(signUpButton)
        Style.styleFilledButton(loginButton)
        
        self.navigationController?.view.backgroundColor = .clear
        
        guard let imageURL = URL(string: "https://raw.githubusercontent.com/Lambda-School-Labs/schematic-capture-fe/google-auth/public/assets/8609f4b9daabe355452ccd4ea682f37e.jpg") else { return }
        do {
            let imageData = try Data(contentsOf: imageURL)
            loginImage.image = UIImage(data: imageData)
        } catch {
            return
        }
        
    }
    
    // Called when the user is signed in with their Google account
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            // With user's Google account, sign in to our firebase
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("\(error)")
                    return
                }
                
                guard authResult != nil else {
                    print("No auth result.")
                    return
                }
                
                // Get ID token (different from authentication.idToken) from our firebase backend
                Auth.auth().currentUser?.getIDToken(completion: { (token, error) in
                   if let error = error {
                        print("\(error)")
                        return
                    }
                    guard let token = token else { return }
                    
                    print("TOKEN: \(token)")
                    
                    // Try loging in first
                    self.loginController.googleLogIn(with: token, completion: { (error) in
                        if let error = error {
                            // If "need register" is returned, create an user with Google's provided name
                            // and direct to google sign up view
                            if error == NetworkingError.needRegister {
                                let firstName = user.profile.givenName
                                let lastName = user.profile.familyName
                                self.loginController.user = User(firstName: firstName ?? "", lastName: lastName ?? "", phone: nil, inviteToken: nil)
                                self.performSegue(withIdentifier: "GoogleSegue", sender: nil)
                                return
                            } else {
                                print("\(error)")
                                return
                            }
                        }
                        
                        // Login successful, direct to the main page
                        DispatchQueue.main.async {
                            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                            let alert = SCLAlertView(appearance: appearance)
                            alert.addButton("Proceed to main page") {
                                self.performSegue(withIdentifier: "MainPageSegue", sender: nil)
                            }
                            alert.showSuccess("Login Success!", subTitle: "")
                        }
                        
                    })
                })
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpSegue" {
            if let signUpVC = segue.destination as? SignUpViewController {
                signUpVC.loginController = loginController
            }
        } else if segue.identifier == "LoginSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.loginController = loginController
            }
        } else if segue.identifier == "HomeVCSegue" {
            if let homeVC = segue.destination as? HomeViewController {
                homeVC.loginController = loginController
            }
        } else if segue.identifier == "GoogleSegue" {
            if let googleVC = segue.destination as? GoogleSignUpViewController {
                googleVC.loginController = loginController
            }
        }
    }
}


//  LoginController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SwiftyDropbox

class AuthorizationController {
    
    let defaults = UserDefaults.standard
    var bearer: Bearer?
    var user: User?
    
    typealias Completion = (Result<[Any], NetworkingError>) -> ()
    
    // AuthenticateUser
    /*Authenticate user with username and password. Save user Id to UserDefaults */
    
    func logIn(username:String, password:String, viewController: UIViewController, completion: @escaping Completion) {
        //configure request url
        let loggingInUser = User(password:password, username:username)
        var internalBearer:Bearer?

        var request = URLRequest(url: URL(string: Urls.logInUrl.rawValue)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(loggingInUser)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user in LogIn: \(error)")
            completion(.failure(.badDecode))
            return
        }
        URLSession.shared.dataTask(with:request) { (data, _, error) in
            if let error = error {
                completion(.failure(.serverError(error)))
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
                        
            let decoder = JSONDecoder()

            do {
                // Get the bearer and the user
                internalBearer = try decoder.decode(Bearer.self, from: data)
                let user = try decoder.decode(User.self, from: data)
                guard let bearer = internalBearer else { return }
                DispatchQueue.main.async {
                    DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                                  controller: viewController,
                                                                  openURL: { (url: URL) -> Void in
                                                                    UIApplication.shared.openURL(url)
                                                                    completion(.success([bearer.token, user]))
                    })
                }
                
            } catch {
                NSLog("Error decoding a bearer token: \(error)")
                completion(.failure(.badDecode))
                return
            }
            self.user = loggingInUser
            self.bearer = internalBearer
            self.defaults.set(internalBearer?.token, forKey: .token)
        }.resume()
    }
    
    
    
    // Password recovery
    /*Starts a new password recovery transaction for a given user and issues a that
     can be used to reset a user's password*/
    
    
    
    // Handle status
    /*Handle current status in order to proceed with the initiated flow*/
    
    
    
    
}

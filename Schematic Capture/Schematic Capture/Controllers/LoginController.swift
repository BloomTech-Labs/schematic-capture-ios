//  LoginController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class AuthorizationController {
    
    let defaults = UserDefaults.standard
    var bearer: Bearer?
    var user: User?
    
    typealias Completion = (Result<Any, NetworkingError>) -> ()
    
    // AuthenticateUser
    /*Authenticate user with username and password. Save user Id to UserDefaults */
    
    func logIn(username:String, password:String, completion: @escaping Completion) {
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
            print("Error encoding user in LogIn: \(error)")
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
                internalBearer = try decoder.decode(Bearer.self, from: data)
                guard let bearer = internalBearer else { return }
                completion(.success(bearer.token))
            } catch {
                print("Error decoding a bearer token: \(error)")
                completion(.failure(.badDecode))
                let dataString = String(decoding:data, as: UTF8.self)
                print("DATA: ", dataString)
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

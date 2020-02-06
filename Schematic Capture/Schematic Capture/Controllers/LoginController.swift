//
//  LoginController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import UIKit

enum HeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

class LogInController {
    
    var bearer: Bearer?
    var user: User?
    private let loginBaseURL = URL(string: "https://sc-be-production.herokuapp.com/api")!
//    private let loginBaseURL = URL(string: "https://sc-be-staging.herokuapp.com/api")!
//    private let loginBaseURL = URL(string: "https://localhost:5000/api")!
    

    
    // MARK: - Sign Up
    func signUp(with user: User, completion: @escaping (NetworkingError?) -> Void) {
        
        // Building the URL
        let requestURL = loginBaseURL.appendingPathComponent("auth").appendingPathComponent("register")
        
        // Building the request
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        let encoder = JSONEncoder()
        
        do {
            request.httpBody = try encoder.encode(user)
            print(String(data: request.httpBody!, encoding: .utf8)!)
        } catch {
            print("Error encoding user object: \(error)")
            completion(.badEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Handle errors
            if let error = error {
                print("Error signing up user: \(error)")
                completion(.serverError(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                print("Error unexpected status Code: \(response.statusCode)")
                if let data = data {
                    if let responseData = String(data: data, encoding: String.Encoding.utf8) {
                        completion(.statusCodeMessage(responseData))
                        return
                    }
                }
                completion(.unexpectedStatusCode(response.statusCode))
                return
            }
            
            guard let data = data else {
                print("No data returned from data task")
                completion(.noData)
                return
            }
            
            print(String(data: data, encoding: String.Encoding.utf8)!)
            
            // Decode User
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                self.user = user
                print("\n\nUSER: \(user)\n\n")
            } catch {
                print("Error decoding the user: \(error)")
                completion(.badDecode)
            }
            
            // Decode bearer
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
                print("\n\nTOKEN: \(bearer.idToken)\n\n")
            } catch {
                print("Error decoding the bearer token: \(error)")
                completion(.noBearer)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    //MARK: - Log In Email / Password
    func logIn(with user: User, completion: @escaping (NetworkingError?) -> Void) {
        
        let requestURL = loginBaseURL.appendingPathComponent("auth").appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
            print(String(data: request.httpBody!, encoding: .utf8)!)
        } catch {
            NSLog("Error encoding user for sign in: \(error)")
            completion(.badEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error signing in user: \(error)")
                completion(.serverError(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                if response.statusCode == 203 {
                    completion(.needRegister)
                    return
                }
                completion(.unexpectedStatusCode(response.statusCode))
                return
            }
            
            guard let data = data else {
                print("No data returned from data task")
                completion(.noData)
                return
            }
            
            // Decode User
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                self.user = user
                print("\n\nUSER: \(user)\n\n")
            } catch {
                print("Error decoding the user: \(error)")
                completion(.badDecode)
            }
            
            // Decode Bearer
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
                print("\n\nTOKEN: \(bearer.idToken)\n\n")
            } catch {
                NSLog("Error decoding the bearer token: \(error)")
                completion(.noBearer)
                return
            }
            completion(nil)
            
        }.resume()
    }
    
    //MARK: - Google Login
    func googleLogIn(with token: String, completion: @escaping (NetworkingError?) -> Void) {
        
        let googleBearer = Bearer(idToken: token)
        self.bearer = googleBearer
        
        let requestURL = loginBaseURL.appendingPathComponent("auth").appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        request.httpMethod = HTTPMethod.post.rawValue
        
        do {
            request.httpBody = try JSONEncoder().encode(self.bearer)
            print(String(data: request.httpBody!, encoding: .utf8)!)
        } catch {
            NSLog("Error encoding user for sign in: \(error)")
            completion(.badEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(.noData)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                if response.statusCode == 203 {
                    completion(.needRegister)
                    return
                }
                completion(.unexpectedStatusCode(response.statusCode))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(.noData)
                return
            }
            
            // Decode User
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                self.user = user
                print("\n\nUSER: \(user)\n\n")
            } catch {
                print("Error decoding the user: \(error)")
                completion(.badDecode)
            }
            
            // Decode Bearer
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
                print("\n\nTOKEN: \(bearer.idToken)\n\n")
            } catch {
                NSLog("Error decoding the bearer token: \(error)")
                completion(.noBearer)
                return
            }
            completion(nil)
            
        }.resume()
    }
}

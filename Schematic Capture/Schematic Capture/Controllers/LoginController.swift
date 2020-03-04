//  LoginController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LogInController {
    
    let defaults = UserDefaults.standard
    
    var bearer: Bearer?
    var user: User?
    
//        private let baseURL = URL(string: "https://sc-be-production.herokuapp.com/api")!
    private let baseURL = URL(string: "https://sc-test-be.herokuapp.com/api")!
//    private let baseURL = URL(string: "https://sc-be-staging.herokuapp.com/api")!
//    private let baseURL = URL(string: "https://localhost:5000/api")!
    
    
    // MARK: - Sign Up
    func signUp(with user: User, completion: @escaping (NetworkingError?) -> Void) {
        
        if let email = user.email,
            let password = user.password,
            user.firstName != nil,
            user.lastName != nil,
            user.phone != nil,
            user.inviteToken != nil {
            
            self.user = user
            googleSignUp(withEmail: email, Password: password) { (error, bearer) in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let bearer = bearer else {
                    print("No bearer returned")
                    completion(.noBearer)
                    return
                }
                
                self.bearer = bearer
                self.registerHttpRequest(bearer: bearer) { (error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    completion(nil)
                }
            }
        } else if let bearer = self.bearer,
            user.firstName != nil,
            user.lastName != nil,
            user.phone != nil,
            user.inviteToken != nil {
            self.user = user
            registerHttpRequest(bearer: bearer) { (error) in
                if let error = error {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
    }
    
    //MARK: - Log In Email / Password
    func logIn(with user: User, completion: @escaping (NetworkingError?) -> Void) {
        // email and password have been already validated
        googleLogin(withEmail: user.email!, password: user.password!) { (error, bearer) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let bearer = bearer else {
                print("No bearer returned")
                completion(.noBearer)
                return
            }
            
            self.loginHttpRequest(bearer: bearer) { (error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
            }
        }
    }
    
    // MARK: - Register HTTP Request
    private func registerHttpRequest(bearer: Bearer, completion: @escaping (NetworkingError?) -> Void) {
        // Building the URL
        let requestURL = self.baseURL.appendingPathComponent("auth").appendingPathComponent("register")
        
        // Building the request
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.idToken)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        //TODO: debug statement
        print("\n\n \(bearer.idToken) \n\n")
        
        let encoder = JSONEncoder()
        
        do {
            request.httpBody = try encoder.encode(user)
            //TODO: debug statement
            print("\n\n \(String(data: request.httpBody!, encoding: .utf8)!) \n\n")
        } catch {
            print("Error encoding user object: \(error)")
            completion(.badEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error signing up user: \(error)")
                completion(.serverError(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                print("Error unexpected status Code: \(response.statusCode)")
                // Display the error message from the backend
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
            //TODO: debug statement
            print("\n\n \(String(data: data, encoding: .utf8)!) \n\n")
            
            // Decode User
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                self.user = user
                
                // update user info
                self.updateUser(user: user)
                print("\n\nUSER: \(user)\n\n")
            } catch {
                print("Error decoding the user: \(error)")
                completion(.badDecode)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    //MARK: - Login HTTP Request
    private func loginHttpRequest(bearer: Bearer, completion: @escaping (NetworkingError?) -> Void) {
        
        self.bearer = bearer
        
        //TODO: Delete
        print(bearer.idToken)
        
        let requestURL = baseURL.appendingPathComponent("auth").appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.idToken)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error signing in user: \(error)")
                completion(.serverError(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                if response.statusCode == 400 {
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
                
                // Update user info
                self.updateUser(user: user)
                print("\n\nUSER: \(user)\n\n")
            } catch {
                print("Error decoding the user: \(error)")
                completion(.badDecode)
                return
            }
            completion(nil)
            
        }.resume()
    }
    
    
    
    //MARK: - Google Sign Up with email and password
    private func googleSignUp(withEmail email: String, Password: String, completion: @escaping (NetworkingError?, Bearer?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: Password) { (authResult, error) in
            if let error = error {
                print(error)
                return completion(.serverError(error), nil)
            }
            
            guard let authResult = authResult else {
                print("googleSignUp(): No auth result returned")
                return completion(.error("No auth result returned"), nil)
            }
            
            
            
            authResult.user.getIDToken { (idToken, error) in
                if let error = error {
                    print(error)
                    return completion(.serverError(error), nil)
                }
                
                guard let idToken = idToken else {
                    print("googleSignUp()::getIdToken(): No ID Token returned")
                    return completion(.error("No ID Token returned"), nil)
                }
                
                
                
                return completion(nil, Bearer(idToken: idToken))
            }
        }
    }
    
    //MARK: - Google Sign In with email and password
    private func googleLogin(withEmail email: String, password: String, completion: @escaping (NetworkingError?, Bearer?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print(error)
                return completion(.serverError(error), nil)
            }
            
            guard let authResult = authResult else {
                print("googleLogin(): No auth result returned")
                return completion(.error("No auth result returned"), nil)
            }
            
            authResult.user.getIDToken { (idToken, error) in
                if let error = error {
                    print(error)
                    return completion(.serverError(error), nil)
                }
                
                guard let idToken = idToken else {
                    print("googleLogin()::getIdToken(): No ID Token returned")
                    return completion(.error("No ID Token returned"), nil)
                }
                
                print("\(idToken)")
                return completion(nil, Bearer(idToken: idToken))
            }
        }
    }
    
    
    //MARK: - Google Login with credential
    func googleLogin(withCredential credential: AuthCredential, completion: @escaping (NetworkingError?) -> Void) {
        
        // Sign in to firebase using user's Google account
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                completion(.serverError(error))
                return
            }
            
            guard authResult != nil else {
                print("No auth result.")
                completion(.error("No auth result returned."))
                return
            }
            
            guard let currentUser = Auth.auth().currentUser else {
                print("Current user not available.")
                completion(.error("Current user not available."))
                return
            }
            
            currentUser.getIDToken(completion: { (idToken, error) in
                if let error = error {
                    print(error)
                    completion(.serverError(error))
                    return
                }
                
                guard let idToken = idToken else {
                    print("No ID Token returned.")
                    completion(.noBearer)
                    return
                }
                
                self.loginHttpRequest(bearer: Bearer(idToken: idToken)) { (error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    completion(nil)
                }
            })
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error)")
            completion(error)
            return
        }
        completion(nil)
    }
    
    //MARK: - Update User
    private func updateUser(user: User) {
        guard let firstName = user.firstName,
            let lastName = user.lastName,
            let organizations = user.organizations,
            !organizations.isEmpty,
            let role = user.role else { return }
        
        do {
            let organizationData = try JSONEncoder().encode(organizations)
            let roleData = try JSONEncoder().encode(role)
            defaults.set(organizationData, forKey: "organizationsJSONData")
            defaults.set(roleData, forKey: "roleJSONData")
            defaults.set(firstName, forKey: "firstName")
            defaults.set(lastName, forKey: "lastName")
        } catch {
            print("\(error)")
            return
        }
    }
}

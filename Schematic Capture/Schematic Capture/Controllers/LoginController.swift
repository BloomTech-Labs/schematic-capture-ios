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
    
     // private let baseURL = URL(string: "https://sc-be-production.herokuapp.com/api")!
  //  private let baseURL = URL(string: "https://sc-test-be.herokuapp.com/api")!
   // private let baseURL = URL(string: "https://sc-be-staging.herokuapp.com/api")!
   private let baseURL = URL(string: "http://localhost:5000/api")!

    
    
//MARK: Sign-Up
    
    
 
    
//MARK:Log-In
    func logIn(username:String, password:String, completion: @escaping (NetworkingError?) -> Void) {
        //configure request url
        let loggingInUser = User(password:password, username:username)
        var internalBearer:Bearer?
        // internal bearer for within the function
        
      
        
        let loginURL = baseURL.appendingPathComponent("auth/login")
        
        var request = URLRequest(url:loginURL)
        print(request.description)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     
        

        
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(loggingInUser)
            let jsonDataString = String(decoding:jsonData, as: UTF8.self)
            print("jsonData is \(jsonDataString)")
            request.httpBody = jsonData
        } catch {
            print("Error encoding user in LogIn LoginController: \(error)")
            completion(NetworkingError.badEncode)
            return
        }
        URLSession.shared.dataTask(with:request) { (data, _, error) in
            if let _ = error {
                completion(NetworkingError.error("Error response from URLSession.shared.dataTask in LoginController"))
                
            }
            guard let data = data else {
                completion(NetworkingError.error("Bad data back from URLSession.shared.dataTask in LoginController"))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                internalBearer = try decoder.decode(Bearer.self, from: data)
                
            } catch {
                print("Error decoding a bearer token: \(error)")
                completion(NetworkingError.error("Error Decoding self.bearer.token in LoginController URLSession.shared.dataTask"))
                let dataString = String(decoding:data, as: UTF8.self)
                print(dataString)
                return
            }
            completion(nil)
            
            self.user = loggingInUser
            self.bearer = internalBearer
            print(self.bearer)
            
        }.resume()
    }
            
        
        
  
        
        // send user to back end for response && Grab Bearer
        
        // Proceed to HomeViewController
    
   
    
    
    
    //MARK:Sign-Out to refactor
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
            let role = user.role else { return }
        
        do {
           
            let roleData = try JSONEncoder().encode(role)
            
            defaults.set(roleData, forKey: "roleJSONData")
            defaults.set(firstName, forKey: "firstName")
            defaults.set(lastName, forKey: "lastName")
        } catch {
            print("\(error)")
            return
        }
    }

}

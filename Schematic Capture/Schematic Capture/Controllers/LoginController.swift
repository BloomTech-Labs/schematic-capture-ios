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

    //var receipts: [Receipt] = []
    
    var bearer: Bearer?
    private let loginBaseURL = URL(string: "https://sc-be-staging.herokuapp.com/api")!

    // MARK: - Sign Up  &  Log In Functions :
    
    // MARK: - Sign Up URLSessionDataTask
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
            NSLog("Error encoding user object: \(error)")
            completion(.badEncode)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Handle errors
            if let error = error {
                NSLog("Error signing up user: \(error)")
                completion(.noData)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                
                completion(.unexpectedStatusCode(response.statusCode))
                return
            }
            completion(nil)
        }.resume()
    }
    
    //MARK: - Log In URLSessionDataTask
    func logIn(with user: User, completion: @escaping (NetworkingError?) -> Void) {
        
        let requestURL = loginBaseURL.appendingPathComponent("login")
        
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
                NSLog("Error signing in user: \(error)")
                completion(.noData)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                
                completion(.unexpectedStatusCode(response.statusCode))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(.noData)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
                print(bearer.token)
            } catch {
                NSLog("Error decoding the bearer token: \(error)")
                completion(.noBearer)
                return
            }
            completion(nil)
            
        }.resume()
    }
}

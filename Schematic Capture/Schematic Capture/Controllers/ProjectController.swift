//
//  ProjectController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData

class ProjectController {
    
    var bearer: Bearer?
    var user: User?
    
    var token: String? {
        didSet {
            getClients(token: token)
        }
    }
    
    typealias Completion = (Result<Any, NetworkingError>) -> ()
    
    func getClients(token: String?) {
        //configure request url
        guard let token = token ?? UserDefaults.standard.string(forKey: .token) else { return }
        var request = URLRequest(url: URL(string: Urls.clientsUrl.rawValue)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        request.setValue("Bearer \(token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with:request) { (data, _, error) in
            if let error = error {
//                completion(.failure(.serverError(error)))
            }
            guard let data = data else {
//                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let clients = try decoder.decode([ClientRepresentation].self, from: data)
                print(clients)
//                completion(.success(clients))
            } catch {
                NSLog("Error decoding a clients: \(error)")
//                completion(.failure(.badDecode))
                return
            }
            let context = CoreDataStack.shared.container.newBackgroundContext()
             CoreDataStack.shared.save(context: context)
        }.resume()
    }
    
    func getProjects(with id: Int, token: String, completion: @escaping Completion) {
        //configure request url
        var requestUrl = URL(string: Urls.clientsUrl.rawValue)!
        
        requestUrl.appendPathComponent("\(id)")
        requestUrl.appendPathComponent("projects")
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        request.setValue("Bearer \(token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with:request) { (data, _, error) in
            if let error = error {
                completion(.failure(.serverError(error)))
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
 
            do {
                let projects = try decoder.decode([ProjectRepresentation].self, from: data)
                completion(.success(projects))
            } catch {
                print("Error decoding a projects: \(error)")
                completion(.failure(.badDecode))
                return
            }
        }.resume()
    }
    
    func getJobSheets(with projectID: Int, token: String, completion: @escaping Completion) {
        //configure request url
        var requestUrl = URL(string: Urls.jobSheetsUrl.rawValue)!
        
        requestUrl.appendPathComponent("\(projectID)")
        requestUrl.appendPathComponent("jobsheets")
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        request.setValue("Bearer \(token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with:request) { (data, _, error) in
            if let error = error {
                completion(.failure(.serverError(error)))
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            do {
                let projects = try decoder.decode([JobSheetRepresentation].self, from: data)
                completion(.success(projects))
            } catch {
                print("Error decoding a job sheets: \(error)")
                completion(.failure(.badDecode))
                return
            }
        }.resume()
    }
    
    func getComponents(with jobSheetID: Int, token: String, completion: @escaping Completion) {
        var requestUrl = URL(string: Urls.componentsUrl.rawValue)!
        
        requestUrl.appendPathComponent("\(jobSheetID)")
        requestUrl.appendPathComponent("components")
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        request.setValue("Bearer \(token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with:request) { (data, _, error) in
            if let error = error {
                completion(.failure(.serverError(error)))
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            do {
                let components = try decoder.decode([ComponentRepresentation].self, from: data)
                completion(.success(components))
            } catch {
                print("Error decoding a components: \(error)")
                completion(.failure(.badDecode))
                return
            }
        }.resume()
    }
}

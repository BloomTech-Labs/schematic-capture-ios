//
//  ProjectController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

class ProjectController {
    
    var bearer: Bearer?
    var user: User?
    
    typealias Completion = (Result<Any, NetworkingError>) -> ()
    
    func getClients(token: String?, completion: @escaping Completion) {
        //configure request url
        guard let token = token ?? UserDefaults.standard.string(forKey: .token) else { return }
        var request = URLRequest(url: URL(string: Urls.clientsUrl.rawValue)!)
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
            do {
                let clients = try decoder.decode([Client].self, from: data)
                print(clients)
                completion(.success(clients))
            } catch {
                NSLog("Error decoding a clients: \(error)")
                completion(.failure(.badDecode))
                return
            }
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
                // make sure this JSON is in the format we expect
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                // try to read out a string array
                print("json:", json)
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            do {
                let projects = try decoder.decode([ProjectRepresentation].self, from: data)
                completion(.success(projects))

//                for var project in projects {
//                    // Get jobsheets for each project
//                    var finalProjects = projects
//                    self.getJobSheets(with: project.id, token: token, completion: { (result) in
//                        if let jobsheets = try? result.get() as? [JobSheetRepresentation] {
//                            project.jobSheets?.append(contentsOf: jobsheets)
//                            finalProjects.append(project)
//                        }
//                    })
//                }
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
                // make sure this JSON is in the format we expect
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                // try to read out a string array
                print("json:", json)
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            do {
                let projects = try decoder.decode([JobSheetRepresentation].self, from: data)
                print("JOBSHEETS: \(projects)")
                completion(.success(projects))
            } catch {
                print("Error decoding a job sheets: \(error)")
                completion(.failure(.badDecode))
                return
            }
        }.resume()
    }
    
}

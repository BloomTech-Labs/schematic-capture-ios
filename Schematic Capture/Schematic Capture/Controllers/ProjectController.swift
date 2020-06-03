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
                let clients = try decoder.decode([ClientRepresentation].self, from: data)
                self.saveToPersistence(value: clients)
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
        
        print("REQUEST URL:", requestUrl)
        
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
            
            //            do {
            //               // make sure this JSON is in the format we expect
            //               if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            //                   // try to read out a string array
            //                   print("JSON: \(json)")
            //               }
            //            } catch let error as NSError {
            //               print("Failed to load: \(error.localizedDescription)")
            //            }
            //
            
            do {
                let projects = try decoder.decode([ProjectRepresentation].self, from: data)
                
                self.saveToPersistence(value: projects)
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
                let jobSheets = try decoder.decode([JobSheetRepresentation].self, from: data)
                self.saveToPersistence(value: jobSheets)
                completion(.success(jobSheets))
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
                
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a string array
                    print("JSON COMPONENTS: \(json)")
                }
                
                let components = try decoder.decode([ComponentRepresentation].self, from: data)
                self.saveToPersistence(value: components)
                completion(.success(components))
            } catch {
                print("Error decoding a components: \(error)")
                completion(.failure(.badDecode))
                return
            }
        }.resume()
    }
    
    // Persistence file url
    var fileURL: URL? {
        let manager = FileManager.default
        guard let documentDir = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentDir.appendingPathComponent("list.plist")
        return fileURL
    }
    
    // Save to persistence
    func saveToPersistence<T: Codable>(value: [T]) {
        guard let url = fileURL else {  return }
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(value)
            try data.write(to: url)
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    // Load from persistence
    func loadFromPersistence<T: Codable>(value: T.Type) -> [T]? {
        guard let url = fileURL else { return nil }
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: url)
            let decodedData = try decoder.decode([T].self, from: data)
            return decodedData
        } catch {
            print("Error decoding data: \(error)")
            return nil
        }
    }
}

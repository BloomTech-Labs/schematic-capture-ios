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
    
    init() {
        getClients(token: nil)
    }
    
    typealias Completion = (Result<Any, NetworkingError>) -> ()
    
    func getClients(token: String?) {
        //configure request url
        guard let token = token ?? UserDefaults.standard.string(forKey: .token) else { return }
        var request = URLRequest(url: URL(string: Urls.clientsUrl.rawValue)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        request.setValue("Bearer \(token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        let context = CoreDataStack.shared.mainContext
        
        URLSession.shared.dataTask(with:request) { (data, _, error) in
            if let error = error {
               NSLog("Error with urlsession, \(error)")
            }
            guard let data = data else {
                return
            }
            
            print("CLIENTS:", data)
            
            let decoder = JSONDecoder()
            do {
                let clients = try decoder.decode([ClientRepresentation].self, from: data)
                for var client in clients {
                    self.getProjects(with: client.id, token: token) { result in
                        if let projects = try? result.get() as? [ProjectRepresentation] {
                            client.projects = projects
                            print("PROJECTS:", client.projects)
                            Client(clientRepresentation: client, context: CoreDataStack.shared.mainContext)
                            for var project in projects {
                                Project(projectRepresentation: project, context: context)
                                self.getJobSheets(with: project.id, token: token) { result in
                                    if let jobSheets = try? result.get() as? [JobSheetRepresentation] {
                                        project.jobsheets = jobSheets
                                        for var jobSheet in jobSheets {
                                            self.getComponents(with: jobSheet.id, token: token) { result in
                                                if let components = try? result.get() as? [ComponentRepresentation] {
                                                    jobSheet.components = components
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    // Save to CoreData
                    
                }
            } catch {
                NSLog("Error decoding a clients: \(error)")
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
                let projects = try decoder.decode([ProjectRepresentation].self, from: data)
                
                self.saveToPersistence()
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
                self.saveToPersistence()
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
                let components = try decoder.decode([ComponentRepresentation].self, from: data)
                self.saveToPersistence()
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
    func saveToPersistence() {
        CoreDataStack.shared.save()
    }
    
    func delete(entrie: ComponentRepresentation) {
//        CoreDataStack.shared.mainContext.delete(entrie)
        saveToPersistence()
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

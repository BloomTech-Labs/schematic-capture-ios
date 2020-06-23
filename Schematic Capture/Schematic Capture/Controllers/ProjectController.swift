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
    
    func getClients(token: String?) {
        //configure request url
        guard let token = token ?? UserDefaults.standard.string(forKey: .token) else { return }

        var request = URLRequest(url: URL(string: Urls.clientsUrl.rawValue)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        request.setValue("Bearer \(token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with:request) { (data, _, error) in
            if let error = error {
               NSLog("Error with urlsession, \(error)")
            }
            guard let data = data else {
                return
            }
                    
            let decoder = JSONDecoder()
            do {
                let clients = try decoder.decode([ClientRepresentation].self, from: data)
                self.saveData(clients: clients, token: token)

            } catch {
                NSLog("Error decoding a clients: \(error)")
                return
            }
        }.resume()
    }
    
    
    func saveData(clients: [ClientRepresentation], token: String) {
        let context = CoreDataStack.shared.mainContext
        context.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        for client in clients {
            if self.checkIfItemExist(id: client.id, entityName: .client) == false {
                Client(clientRepresentation: client, context: context)
            }
            self.getProjects(with: client.id, token: token) { result in
                if let projects = try? result.get() as? [ProjectRepresentation] {
                    for var project in projects {
                        if self.checkIfItemExist(id: project.id, entityName: .project) == false {
                            Project(projectRepresentation: project, context: context)
                        }
                        self.getJobSheets(with: project.id, token: token) { result in
                            if let jobSheets = try? result.get() as? [JobSheetRepresentation] {
                                project.jobsheets = jobSheets
                                for var jobSheet in jobSheets {
                                    if self.checkIfItemExist(id: jobSheet.id, entityName: .jobSheet) == false {
                                        JobSheet(jobSheetRepresentation: jobSheet, context: context)
                                    }
                                    self.getComponents(with: jobSheet.id, token: token) { result in
                                        if let components = try? result.get() as? [ComponentRepresentation] {
                                            jobSheet.components = components
                                            for component in components {
                                                if self.checkIfItemExist(id: component.id, entityName: .component) == false {
                                                    Component(componentRepresentation: component, context: context)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
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
    
    func updateComponent(component: Component) {
        
//        var request = URLRequest(url: URL(string: Urls.logInUrl.rawValue)!)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let jsonEncoder = JSONEncoder()
//        do {
//            let jsonData = try jsonEncoder.encode(loggingInUser)
//            request.httpBody = jsonData
//        } catch {
//            NSLog("Error encoding user in LogIn: \(error)")
//            completion(.failure(.badDecode))
//            return
//        }
//        URLSession.shared.dataTask(with:request) { (data, _, error) in
//            if let error = error {
//                completion(.failure(.serverError(error)))
//            }
//            guard let data = data else {
//                completion(.failure(.noData))
//                return
//            }
//            
//            let decoder = JSONDecoder()
//            
//            do {
//               
//            } catch {
//                NSLog("Error decoding a bearer token: \(error)")
//                return
//            }
//        }.resume()
        
    }
    
    // Save to persistence
    func saveToPersistence() {
        CoreDataStack.shared.save()
    }

    
    func checkIfItemExist(id: Int, entityName: EntityNames) -> Bool {
        let managedContext = CoreDataStack.shared.mainContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let count = try managedContext.count(for: fetchRequest)
            if count > 0 {
                return true
            } else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
}

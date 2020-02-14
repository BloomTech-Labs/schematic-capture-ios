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
    var projects: [ProjectRepresentation] = []
    
    //    private let baseURL = URL(string: "https://sc-be-production.herokuapp.com/api")!
    private let baseURL = URL(string: "https://sc-be-staging.herokuapp.com/api")!
    
    // Download assigned jobs (get client, project, job, csv as json)
    func downloadAssignedJobs(completion: @escaping (NetworkingError?) -> Void = { _ in }) {
        
        guard let bearer = self.bearer else {
            completion(.noBearer)
            return
        }
        
        let requestURL = self.baseURL.appendingPathComponent("assignedJobs")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.idToken)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Errer getting assigned jobs: \(error)")
                completion(.serverError(error))
                return
            }
            
            guard let data = data else {
                print("No data returned from data task")
                completion(.noData)
                return
            }
            
            //TODO: debug statement
            print("\n\n \(String(data: data, encoding: .utf8)!) \n\n")
            
            // decode projects
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let projectsRep = try decoder.decode([ProjectRepresentation].self, from: data)
                
                self.updateProjects(with: projectsRep)
                self.projects = projectsRep
                
                print("\n\nPROJECTS: \(self.projects)\n\n")
            } catch {
                print("Error decoding the jobs: \(error)")
                completion(.badDecode)
            }
            
            completion(nil)
        }.resume()
    }
    
    
    private func updateProjects(with representations: [ProjectRepresentation]) {
        let identifiersToFetch = representations.map({ $0.id })
        
        // [UUID: TaskRepresentation]
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        // Make a mutable copy of the dictionary above
        var projectsToCreate = representationsByID
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            
            do {
                // Figure out which ones are new
                let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", identifiersToFetch)
                
                // We need to run the context.fetch on the main queue, because the context is the main context
                let existingProjects = try context.fetch(fetchRequest)
                
                // Update the ones we do have
                for project in existingProjects {
                    // Grab the ProjectRepresentation that corresponds to this Project
                    let id = Int(project.id)
                    guard let representation = representationsByID[id] else { continue }
                    
                    // update the ones that are in core data
                    project.name = representation.name
                    project.client = representation.client
                    project.clientId = Int32(representation.clientId)
                    let jobSheetArr = representation.jobSheets
                    project.jobSheets = jobSheetArr != nil ? NSSet(array: jobSheetArr!) : nil
                    
                    // We just updated a task, we don't need to create a new Task for this identifier
                    projectsToCreate.removeValue(forKey: id)
                }
                
                // Figure out which ones we don't have
                for representation in projectsToCreate.values {
                    Project(projectRepresentation: representation, context: context)
                }
                
                // Persist all the changes (updating and creating of tasks) to Core Data
                CoreDataStack.shared.save(context: context)
                
            } catch {
                NSLog("Erro fetching tasks from persistent store: \(error)")
            }
        }
        
    }
    
    // Download schematic from firebase storage
    
    // Upload jobs in core data (check the status of the jobs)
    
}

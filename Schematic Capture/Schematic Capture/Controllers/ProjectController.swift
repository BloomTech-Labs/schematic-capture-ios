//
//  ProjectController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData
import FirebaseStorage

class ProjectController {
    
    var bearer: Bearer?
    var user: User?
    var projects: [ProjectRepresentation] = []
    
  // private let baseURL = URL(string: "https://sc-be-production.herokuapp.com/api")!
//    private let baseURL = URL(string: "https://sc-be-staging.herokuapp.com/api")!
   // private let baseURL = URL(string: "https://sc-test-be.herokuapp.com/api")!
     private let baseURL = URL(string: "http://localhost:5000/api")!
    
    // Download assigned jobs (get client, project, job, csv as json)
    func downloadAssignedJobs(completion: @escaping (NetworkingError?) -> Void = { _ in }) {
        
        guard let bearer = self.bearer else {
            completion(.noBearer)
            return
        }
        
        let requestURL = self.baseURL.appendingPathComponent("jobsheets").appendingPathComponent("assigned")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error getting assigned jobs: \(error)")
                completion(.serverError(error))
                return
            }
            
            guard let data = data else {
                print("No data returned from data task")
                completion(.noData)
                return
            }
            
            //TODO: debug statement
            print("\ninside download assigned jobs\n \(String(data: data, encoding: .utf8)!) \n\n")
            
            // decode projects
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let projectsRep = try decoder.decode([ProjectRepresentation].self, from: data)
                
                self.updateProjects(with: projectsRep)
                self.projects = projectsRep
                self.projects.sort { $0.id < $1.id }
                print("\n\nPROJECTS: \(self.projects)\n\n")
            } catch {
                print("Error decoding the jobs: \(error)")
                completion(.badDecode)
            }
            
            completion(nil)
        }.resume()
        print("0. Last line of downloadAssigned Jobs Executed")
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
//                    guard let representation = representationsByID[id] else { continue }
//                    // update the ones that are in core data
//                    project.name = representation.name
//                    //project.clientId = representation.clientId
//                    project.clientId = Int32(representation.clientId)
//                    let jobSheetArr = representation.jobSheets
//                    project.jobSheets = jobSheetArr != nil ? NSSet(array: jobSheetArr!) : nil
//
//                    // We just updated a task, we don't need to create a new Task for this identifier
                    projectsToCreate.removeValue(forKey: id)
                }

                // Figure out which ones we don't have
                for representation in projectsToCreate.values {
                    // Create Projects from project representations
                    let project = Project(projectRepresentation: representation, context: context)

                    // Connect JobSheet to Project relationship
                    if let jobSheetsSet = project.jobSheets,
                        let jobSheets = jobSheetsSet.sortedArray(using: [NSSortDescriptor(key: "id", ascending: true)]) as? [JobSheet] {
                        for jobSheet in  jobSheets{
                            jobSheet.ownedProject = project

                            // Connect Component to JobSheet relationship
                            if let componentsSet = jobSheet.components,
                                let components = componentsSet.sortedArray(using: [NSSortDescriptor(key: "id", ascending: true)]) as? [Component] {
                                for component in components {
                                    component.ownedJobSheet = jobSheet

                                    // Connect Photo to Component relationship
                                    if let photo = component.photo {
                                        photo.ownedComponent = component
                                    }
                                }
                            }
                        }
                    }
                }

                // Persist all the changes (updating and creating of tasks) to Core Data
                CoreDataStack.shared.save(context: context)

            } catch {
                NSLog("Error fetching tasks from persistent store: \(error)")
            }
        }
        print("1.Last line of updateProjects executed")
    }
    
    // Download schematic from firebase storage
    func downloadSchematics(completion: @escaping (NetworkingError?) -> Void = { _ in }) {

        guard let user = user, let _ = bearer else {
            completion(.noBearer)
            return
        }



        let maxSize: Int64 = 1073741824 // 1GB
        let storage = Storage.storage()
        let storageRef = storage.reference()
        for project in projects {

            guard var jobSheets = project.jobSheets else {
                completion(.error("No job sheets found"))
                return
            }

            jobSheets.sort { $0.id < $1.id }

            for jobSheet in jobSheets {
                var pdfRef: String?
                let schematicRef = storageRef.child("\(project.clientId)")
                   
                    
                    .child("\(project.id)")
                    .child("\(jobSheet.id)")

                schematicRef.listAll { (listResult, error) in
                    if let error = error {
                        completion(.error("\(error)"))
                        return
                    }

                    let listFullPaths = listResult.items.map { $0.fullPath }
                    for path in listFullPaths {
                        if path.contains(".PDF") || path.contains(".pdf") {
                            pdfRef = path
                            break
                        }
                    }

//                    guard let pdfRef = pdfRef else {
//                        completion(.error("No PDF file found in \(schematicRef.fullPath)"))
//                        return
//                    }
                    
                    // commenting out so that no pdf wont break function

//                    let start = pdfRef.lastIndex(of: "/")!
//                    let newStart = pdfRef.index(after: start)
//                    let range = newStart..<pdfRef.endIndex
//                    let pdfNameString = String(pdfRef[range])
//
//                    schematicRef.child(pdfNameString).getData(maxSize: maxSize) { (data, error) in
//                        if let error = error {
//                            print("\(error)")
//                            completion(.serverError(error))
//                            return
//                        }

//                        guard let data = data else {
//                            print("No schematic pdf returned")
//                            completion(.noData)
//                            return
//                        }
//                        self.updateSchematic(pdfData: data, name: pdfNameString, jobSheetRep: jobSheet)
//                        completion(nil)
//                    }
//                }
            }
        }
            print("2. Last line of DownloadSchematics executed")
    }
//

     func updateSchematic(pdfData: Data, name: String, jobSheetRep: JobSheetRepresentation) {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.performAndWait {
            do {
                // Figure out which ones are new
                let fetchRequest: NSFetchRequest<JobSheet> = JobSheet.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "projectId == %@ AND id == %@", NSNumber(value: jobSheetRep.projectId), NSNumber(value: jobSheetRep.id))

                // We need to run the context.fetch on the main queue, because the context is the main context
                let jobSheets = try context.fetch(fetchRequest)

                // There should only one job sheet with the given ID
                if let jobSheet = jobSheets.first {
                    //jobSheet.schematicData = pdfData
                    jobSheet.schematicName = name

                    CoreDataStack.shared.save(context: context)
                }
            } catch {
                NSLog("Error fetching tasks from persistent store: \(error)")
            }
        }
    }
        print("3.last line of update schematics executed")

   //  Upload jobs in core data (check the status of the jobs)
    
}
}

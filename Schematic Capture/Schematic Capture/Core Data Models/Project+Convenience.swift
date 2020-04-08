//
//  Project+Convenience.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/6/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

extension Project {
    // COMPUTED PROP projectRepresentation directly on Project, its getting all its attributes from Person, generated automatically.
    var projectRepresentation: ProjectRepresentation? {
        guard let name = name else { return nil }
        // Sort the job sheet array by id
        let idDescriptor = NSSortDescriptor(key: "id", ascending: true)
        // convert NSSet to an array, if nil, return nil
        let jobSheetsArr = jobSheets != nil ? (jobSheets!.sortedArray(using: [idDescriptor]) as? [JobSheetRepresentation]) : nil
        return ProjectRepresentation(id: Int(id), name: name, jobSheets: jobSheetsArr,  clientId: Int(clientId),  completed:Int(completed))
    }
    // Projects convenience init itself
    
    @discardableResult convenience init(id: Int,
                                        name: String,
                                        jobSheets: [JobSheet]?,
                                        
                                        clientId: Int,
                                        
                                        completed:Int,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int32(id)
        self.name = name
        self.jobSheets = jobSheets != nil ? NSSet(array: jobSheets!) : nil
        
        self.clientId = Int32(clientId)
        
        self.completed = Int32(completed)
    }
    
    //Initializer for Project that takes in a projectRepresentation and creates a person from its values.
    
    @discardableResult convenience init(projectRepresentation: ProjectRepresentation, context: NSManagedObjectContext) {
        
        let jobSheets = projectRepresentation.jobSheets != nil ? projectRepresentation.jobSheets!.map { JobSheet(jobSheetRepresentation: $0, context: context) } : nil
        
        self.init (id: projectRepresentation.id,
            name: projectRepresentation.name,
            jobSheets: jobSheets,
            clientId: projectRepresentation.clientId, 
            completed:projectRepresentation.completed,
            context: context)
    }
}

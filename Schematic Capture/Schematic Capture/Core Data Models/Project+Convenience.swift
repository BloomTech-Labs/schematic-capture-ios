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
        guard let name = name, let jobsheets = jobsheets else { return nil }
        // Sort the job sheet array by id
        let idDescriptor = NSSortDescriptor(key: "id", ascending: true)
        // convert NSSet to an array, if nil, return nil
        let jobSheetsArr = jobsheets.sortedArray(using: [idDescriptor]) as? [JobSheetRepresentation]
        return ProjectRepresentation(id: Int(id), name: name, jobsheets: jobSheetsArr,  clientId: Int(clientId),  completed: completed)
    }
    // Projects convenience init itself
    
    @discardableResult convenience init(id: Int, name: String, jobSheets: [JobSheetRepresentation]?, clientId: Int,
                                        completed:Bool,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int32(id)
        self.name = name
        self.jobsheets = jobsheets
        self.clientId = Int32(clientId)
        self.completed = completed
    }
    
    //Initializer for Project that takes in a projectRepresentation and creates a person from its values.
    
    @discardableResult convenience init(projectRepresentation: ProjectRepresentation, context: NSManagedObjectContext) {

        self.init (id: projectRepresentation.id,
                   name: projectRepresentation.name ?? "",
                   jobSheets: projectRepresentation.jobsheets,
                   clientId: projectRepresentation.clientId ?? 0,
                   completed:projectRepresentation.completed ?? false,
                   context: context)
    }
}

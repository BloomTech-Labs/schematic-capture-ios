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
    var projectRepresentation: ProjectRepresentation? {
        guard let name = name, let client = client else { return nil }
        // Sort the job sheet array by id
        let idDescriptor = NSSortDescriptor(key: "id", ascending: true)
        // convert NSSet to an array, if nil, return nil
        let jobSheetsArr = jobSheets != nil ? (jobSheets!.sortedArray(using: [idDescriptor]) as? [JobSheetRepresentation]) : nil
        return ProjectRepresentation(id: Int(id), name: name, jobSheets: jobSheetsArr, client: client, clientId: Int(clientId))
    }
    
    @discardableResult convenience init(id: Int,
                                        name: String,
                                        jobSheets: [JobSheet]?,
                                        client: String,
                                        clientId: Int,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int32(id)
        self.name = name
        self.jobSheets = jobSheets != nil ? NSSet(array: jobSheets!) : nil
        self.client = client
        self.clientId = Int32(clientId)
    }
    
    @discardableResult convenience init?(projectRepresentation: ProjectRepresentation, context: NSManagedObjectContext) {
        
        let jobSheets = projectRepresentation.jobSheets != nil ? projectRepresentation.jobSheets!.map { JobSheet(jobSheetRepresentation: $0, context: context) } : nil
        
        self.init (id: projectRepresentation.id,
            name: projectRepresentation.name,
            jobSheets: jobSheets,
            client: projectRepresentation.client,
            clientId: projectRepresentation.clientId,
            context: context)
    }
}

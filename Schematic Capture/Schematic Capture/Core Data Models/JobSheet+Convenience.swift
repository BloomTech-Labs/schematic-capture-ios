//
//  JobSheet+Convenience.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/6/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

enum JobSheetStatus: String, CaseIterable {
    case incomplete
    case inProgress
    case complete
    case assigned
}

extension JobSheet {
    
    var jobSheetRepresentation: JobSheetRepresentation? {
        guard let name = name,
            let updatedAt = updatedAt,
            let status = status else { return nil }
        
        // Sort the job sheet array by component id
        let componentIdDescriptor = NSSortDescriptor(key: "componentId", ascending: true)
        // convert NSSet to an array, if nil, return nil
        let componentsArr = components != nil ? (components!.sortedArray(using: [componentIdDescriptor]) as? [ComponentRepresentation]) : nil
        
        return JobSheetRepresentation(id: Int(id),
                                      name: name,
                                      schematic: schematic,
                                      updatedAt: updatedAt,
                                      status: status,
                                      projectId: Int(projectId),
                                      userEmail: userEmail,
                                      completed: completed,
                                      components: componentsArr
        ) }
    
    @discardableResult convenience init(id: Int,
                                        name: String,
                                        components: [Component]?,
                                        schematic: String?,
                                        updatedAt: String,
                                        status: JobSheetStatus,
                                        projectId: Int,
                                        userEmail: String,
                                        completed: Bool,
                                        
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int32(id)
        self.name = name
        self.components = components != nil ? NSOrderedSet(array: components!) : nil
        self.schematic = schematic
        self.updatedAt = updatedAt
        self.status = status.rawValue
        self.projectId = Int32(projectId)
        self.userEmail = userEmail
        self.completed = completed
    }
    
    @discardableResult convenience init(jobSheetRepresentation: JobSheetRepresentation, context: NSManagedObjectContext) {
        
        let components = jobSheetRepresentation.components != nil ? jobSheetRepresentation.components!.map { Component(componentRepresentation: $0, context: context) } : nil
        
        self.init(id: jobSheetRepresentation.id,
                  name: jobSheetRepresentation.name,
                  components: components,
                  schematic: jobSheetRepresentation.schematic,
                  updatedAt: jobSheetRepresentation.updatedAt,
                  status: JobSheetStatus(rawValue: jobSheetRepresentation.status) ?? JobSheetStatus.incomplete,
                  projectId: jobSheetRepresentation.projectId,
                  userEmail: jobSheetRepresentation.userEmail ?? "",
                  completed: jobSheetRepresentation.completed,
                  context: context)
        
    }
}

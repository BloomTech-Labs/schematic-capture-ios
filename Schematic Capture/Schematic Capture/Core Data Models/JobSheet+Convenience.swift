//
//  JobSheet+Convenience.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/6/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

extension JobSheet {
    
    var jobSheetRepresentation: JobSheetRepresentation? {
        guard let name = name,
            let updatedAt = updatedAt,
            let ownedProject = ownedProject,
            let ownedProjectRep = ownedProject.projectRepresentation else { return nil }
        
        // Sort the job sheet array by component id
        let componentIdDescriptor = NSSortDescriptor(key: "componentId", ascending: true)
        // convert NSSet to an array, if nil, return nil
        let componentsArr = components != nil ? (components!.sortedArray(using: [componentIdDescriptor]) as? [ComponentRepresentation]) : nil
        
        // Sort the job sheet array by component id
        let photoNameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        // convert NSSet to an array, if nil, return nil
        let photosArr = photos != nil ? (photos!.sortedArray(using: [photoNameDescriptor]) as? [PhotoRepresentation]) : nil
        
        return JobSheetRepresentation(id: Int(id),
                                      name: name,
                                      components: componentsArr,
                                      schematic: schematic,
                                      photos: photosArr,
                                      updatedAt: updatedAt,
                                      ownedProject: ownedProjectRep)
    }
    
    @discardableResult convenience init(id: Int,
                                        name: String,
                                        components: [Component]?,
                                        schematic: Data?,
                                        photos: [Photo]?,
                                        updatedAt: String,
                                        ownedProject: Project,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int32(id)
        self.name = name
        self.components = components != nil ? NSSet(array: components!) : nil
        self.schematic = schematic
        self.photos = photos != nil ? NSSet(array: photos!) : nil
        self.updatedAt = updatedAt
        self.ownedProject = ownedProject
    }
    
    @discardableResult convenience init(jobSheetRepresentation: JobSheetRepresentation, context: NSManagedObjectContext) {
        
        let components = jobSheetRepresentation.components != nil ? jobSheetRepresentation.components!.map { Component(componentRepresentation: $0, context: context) } : nil
        
        let photos = jobSheetRepresentation.photos != nil ? jobSheetRepresentation.photos!.map { Photo(photoRepresentation: $0, context: context) } : nil
        
        self.init(id: jobSheetRepresentation.id,
                  name: jobSheetRepresentation.name,
                  components: components,
                  schematic: jobSheetRepresentation.schematic,
                  photos: photos,
                  updatedAt: jobSheetRepresentation.updatedAt,
                  ownedProject: Project(projectRepresentation: jobSheetRepresentation.ownedProject, context: context),
                  context: context)
    }
}

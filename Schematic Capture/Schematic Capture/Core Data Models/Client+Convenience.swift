//
//  Client+Convenience.swift
//  Schematic Capture
//
//  Created by Ufuk Türközü on 26.05.20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

extension Client {
    
    var clientRepresentation: ClientRepresentation? {
        
        return ClientRepresentation(id: Int(id),
                                    companyName: companyName,
                                    phone: phone,
                                    street: street,
                                    city: city,
                                    state: state,
                                    zip: zip,
                                    projects: projects,
                                    completed: completed)
    }
    
    @discardableResult convenience init(id: Int,
                            companyName: String?,
                            phone: String?,
                            street: String?,
                            city: String?,
                            state: String?,
                            zip: String?,
                            completed: Bool?,
                            projects: String?,
                            context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.id = Int16(id)
        self.companyName = companyName
        self.phone = phone
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        self.completed = completed ?? false
        self.projects = projects
    }
    
    @discardableResult convenience init(clientRepresentation: ClientRepresentation, context: NSManagedObjectContext) {
        
        self.init(id: clientRepresentation.id,
                  companyName: clientRepresentation.companyName,
                  phone: clientRepresentation.phone,
                  street: clientRepresentation.street,
                  city: clientRepresentation.city,
                  state: clientRepresentation.state,
                  zip: clientRepresentation.zip,
                  completed: clientRepresentation.completed,
                  projects: clientRepresentation.projects,
                  context: context)
    }
}

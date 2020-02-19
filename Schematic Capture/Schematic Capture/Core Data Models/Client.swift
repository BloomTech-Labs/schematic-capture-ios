//
//  Client.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/6/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

extension Client {
    
    @discardableResult convenience init(name: String,
                                        imageData: Data?,
                                        projects: [Project]?,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.imageData = imageData
        self.projects = projects != nil ? NSSet(array: projects!) : nil
    }
}

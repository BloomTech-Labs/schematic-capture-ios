//
//  Job+Convenience.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/6/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

extension Job {
    
    @discardableResult convenience init(name: String,
                                        jobSheets: [JobSheet]?,
                                        schematic: Data?,
                                        photos: [Photo]?,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.jobSheets = jobSheets != nil ? NSSet(array: jobSheets!) : nil
        self.schematic = schematic
        self.photos = photos != nil ? NSSet(array: photos!) : nil
    }
}

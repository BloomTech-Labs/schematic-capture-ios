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
    
    @discardableResult convenience init(name: String,
                                        jobSheets: [JobSheet]?,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.jobSheets = jobSheets != nil ? NSSet(array: jobSheets!) : nil
    }
}

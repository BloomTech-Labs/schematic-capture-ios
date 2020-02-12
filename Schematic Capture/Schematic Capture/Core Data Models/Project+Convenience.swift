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
}

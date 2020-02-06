//
//  Organization+Convenience.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/6/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

extension Organization {
    
    @discardableResult convenience init(name: String,
                                        clients: [Client]?,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.clients = clients != nil ? NSSet(array: clients!) : nil
    }
}

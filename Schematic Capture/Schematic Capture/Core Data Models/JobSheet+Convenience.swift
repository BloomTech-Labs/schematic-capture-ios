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
    
    @discardableResult convenience init(id: Int,
                                        name: String,
                                        components: [Component]?,
                                        schematic: Data?,
                                        photos: [Photo]?,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int32(id)
        self.name = name
        self.components = components != nil ? NSSet(array: components!) : nil
        self.schematic = schematic
        self.photos = photos != nil ? NSSet(array: photos!) : nil
    }
}

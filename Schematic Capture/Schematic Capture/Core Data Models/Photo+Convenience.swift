//
//  Photo+Convenience.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/6/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

extension Photo {
    
    @discardableResult convenience init(name: String,
                                        imageData: Data,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.imageData = imageData
    }
}

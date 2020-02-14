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
    
    var photoRepresentation: PhotoRepresentation? {
        guard let name = name,
            let imageData = imageData,
            let ownedJobSheet = ownedJobSheet,
            let ownedJobSheetRep = ownedJobSheet.jobSheetRepresentation else { return nil }
        return PhotoRepresentation(name: name,
                                   imageData: imageData,
                                   ownedJobSheet: ownedJobSheetRep)
    }
    
    @discardableResult convenience init(name: String,
                                        imageData: Data,
                                        ownedJobSheet: JobSheet,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.imageData = imageData
        self.ownedJobSheet = ownedJobSheet
    }
    
    @discardableResult convenience init(photoRepresentation: PhotoRepresentation, context: NSManagedObjectContext) {
        self.init(name: photoRepresentation.name,
                  imageData: photoRepresentation.imageData,
                  ownedJobSheet: JobSheet(jobSheetRepresentation: photoRepresentation.ownedJobSheet, context: context),
                  context: context)
    }
}

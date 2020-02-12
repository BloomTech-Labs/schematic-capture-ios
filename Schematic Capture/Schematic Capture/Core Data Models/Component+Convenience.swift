//
//  Component+Convenience.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/6/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

enum JobSheetStatus: String, CaseIterable {
    case incomplete
    case inProgress
    case complete
}

extension Component {
    
    @discardableResult convenience init(componentId: String,
                                        manufacturer: String?,
                                        partNumber: String?,
                                        rlCategory: String?,
                                        rlNumber: String?,
                                        stockCode: String?,
                                        electricalAddress: String?,
                                        componentApplication: String?,
                                        referenceTag: String?,
                                        settings: String?,
                                        image: String?,
                                        resources: String?,
                                        cutSheet: String?,
                                        maintenanceVideo: String?,
                                        storePartNumber: String?,
                                        status: JobSheetStatus,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.componentId = componentId
        self.manufacturer = manufacturer
        self.partNumber = partNumber
        self.rlCategory = rlCategory
        self.rlNumber = rlNumber
        self.stockCode = stockCode
        self.electricalAddress = electricalAddress
        self.componentApplication = componentApplication
        self.referenceTag = referenceTag
        self.settings = settings
        self.image = image
        self.resources = resources
        self.cutSheet = cutSheet
        self.maintenanceVideo = maintenanceVideo
        self.storePartNumber = storePartNumber
        self.status = status.rawValue
    }
}

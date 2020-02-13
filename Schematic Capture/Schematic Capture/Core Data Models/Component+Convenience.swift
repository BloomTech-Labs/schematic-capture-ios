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
    
    var componentRepresentation: ComponentRepresentation? {
        guard let componentId = componentId,
            let manufacturer = manufacturer,
            let partNumber = partNumber,
            let rlCategory = rlCategory,
            let rlNumber = rlNumber,
            let stockCode = stockCode,
            let electricalAddress = electricalAddress,
            let componentApplication = componentApplication,
            let referenceTag = referenceTag,
            let settings = settings,
            let image = image,
            let resources = resources,
            let cutSheet = cutSheet,
            let maintenanceVideo = maintenanceVideo,
            let storePartNumber = storePartNumber,
            let status = status else { return nil }
        
        return ComponentRepresentation(componentId: componentId,
                                       manufacturer: manufacturer,
                                       partNumber: partNumber,
                                       rlCategory: rlCategory,
                                       rlNumber: rlNumber,
                                       stockCode: stockCode,
                                       electricalAddress: electricalAddress,
                                       componentApplication: componentApplication,
                                       referenceTag: referenceTag,
                                       settings: settings,
                                       image: image,
                                       resources: resources,
                                       cutSheet: cutSheet,
                                       maintenanceVideo: maintenanceVideo,
                                       storePartNumber: storePartNumber,
                                       status: status)
    }
    
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
    
    @discardableResult convenience init(componentRepresentation: ComponentRepresentation, context: NSManagedObjectContext) {
        
        self.init(componentId: componentRepresentation.componentId,
                  manufacturer: componentRepresentation.manufacturer,
                  partNumber: componentRepresentation.partNumber,
                  rlCategory: componentRepresentation.rlCategory,
                  rlNumber: componentRepresentation.rlNumber,
                  stockCode: componentRepresentation.stockCode,
                  electricalAddress: componentRepresentation.electricalAddress,
                  componentApplication: componentRepresentation.componentApplication,
                  referenceTag: componentRepresentation.referenceTag,
                  settings: componentRepresentation.settings,
                  image: componentRepresentation.image,
                  resources: componentRepresentation.resources,
                  cutSheet: componentRepresentation.cutSheet,
                  maintenanceVideo: componentRepresentation.maintenanceVideo,
                  storePartNumber: componentRepresentation.storePartNumber,
                  status: JobSheetStatus(rawValue: componentRepresentation.status) ?? JobSheetStatus.incomplete,
                  context: context)
    }
}

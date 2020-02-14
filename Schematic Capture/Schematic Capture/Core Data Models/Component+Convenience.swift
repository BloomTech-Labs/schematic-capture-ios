//
//  Component+Convenience.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/6/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData



extension Component {
    
    var componentRepresentation: ComponentRepresentation? {
        guard let componentId = componentId,
            let rlCategory = rlCategory,
            let rlNumber = rlNumber,
            let componentDescription = componentDescription,
            let manufacturer = manufacturer,
            let partNumber = partNumber,
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
            let ownedJobSheet = ownedJobSheet,
            let custom = custom,
            let ownedJobSheetRep = ownedJobSheet.jobSheetRepresentation else { return nil }
        
        return ComponentRepresentation(componentId: componentId,
                                       rlCategory: rlCategory,
                                       rlNumber: rlNumber,
                                       componentDescription: componentDescription,
                                       manufacturer: manufacturer,
                                       partNumber: partNumber,
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
                                       custom: custom,
                                       ownedJobSheet: ownedJobSheetRep)
    }
    
    @discardableResult convenience init(componentId: String,
                                        rlCategory: String?,
                                        rlNumber: String?,
                                        componentDescription: String?,
                                        manufacturer: String?,
                                        partNumber: String?,
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
                                        custom: String?,
                                        ownedJobSheet: JobSheet,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.componentId = componentId
        self.rlCategory = rlCategory
        self.rlNumber = rlNumber
        self.componentDescription = componentDescription
        self.manufacturer = manufacturer
        self.partNumber = partNumber
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
        self.custom = custom
        self.ownedJobSheet = ownedJobSheet
    }
    
    @discardableResult convenience init(componentRepresentation: ComponentRepresentation, context: NSManagedObjectContext) {
        
        self.init(componentId: componentRepresentation.componentId,
                  rlCategory: componentRepresentation.rlCategory,
                  rlNumber: componentRepresentation.rlNumber,
                  componentDescription: componentRepresentation.componentDescription,
                  manufacturer: componentRepresentation.manufacturer,
                  partNumber: componentRepresentation.partNumber,
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
                  custom: componentRepresentation.custom,
                  ownedJobSheet: JobSheet(jobSheetRepresentation: componentRepresentation.ownedJobSheet, context: context),
                  context: context)
    }
}

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
        return ComponentRepresentation(id: Int(id),
                                       componentId: componentId, 
                                       rlCategory: rlCategory,
                                       rlNumber: rlNumber,
                                       descriptions: descriptions,
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
                                       custom: custom
//                                       jobSheetId: Int(jobSheetId)
                                       /*photo: photo?.photoRepresentation*/)
    }
    
    @discardableResult convenience init(id: Int,
                                        componentId: String?,
                                        rlCategory: String?,
                                        rlNumber: String?,
                                        descriptions: String?,
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
//                                        jobSheetId: Int,
                                        //photo: Photo?,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int32(id)
        self.componentId = componentId
        self.rlCategory = rlCategory
        self.rlNumber = rlNumber
        self.descriptions = descriptions
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
        //self.photo = photo
//        self.jobSheetId = Int32(jobSheetId)
    }
    
    @discardableResult convenience init(componentRepresentation: ComponentRepresentation, context: NSManagedObjectContext) {
        
        self.init(id: componentRepresentation.id,
                  componentId: componentRepresentation.componentId,
                  rlCategory: componentRepresentation.rlCategory,
                  rlNumber: componentRepresentation.rlNumber,
                  descriptions: componentRepresentation.descriptions,
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
//                  jobSheetId: componentRepresentation.jobSheetId,
                  //photo: componentRepresentation.photo != nil ? Photo(photoRepresentation: componentRepresentation.photo!, context: context) : nil,
                  context: context)
    }
}

//
//  JobSheet+CoreDataProperties.swift
//  
//
//  Created by Gi Pyo Kim on 2/6/20.
//
//

import Foundation
import CoreData


extension JobSheet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JobSheet> {
        return NSFetchRequest<JobSheet>(entityName: "JobSheet")
    }

    @NSManaged public var componentApplication: String?
    @NSManaged public var componentDescription: String?
    @NSManaged public var componentId: String?
    @NSManaged public var cutSheet: String?
    @NSManaged public var electricalAddress: String?
    @NSManaged public var image: String?
    @NSManaged public var maintenanceVideo: String?
    @NSManaged public var manufacturer: String?
    @NSManaged public var partNumber: String?
    @NSManaged public var referenceTag: String?
    @NSManaged public var resources: String?
    @NSManaged public var settings: String?
    @NSManaged public var stockCode: String?
    @NSManaged public var storePartNumber: String?
    @NSManaged public var status: String?

}

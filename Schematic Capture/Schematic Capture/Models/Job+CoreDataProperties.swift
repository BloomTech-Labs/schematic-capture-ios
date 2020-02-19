//
//  Job+CoreDataProperties.swift
//  
//
//  Created by Gi Pyo Kim on 2/6/20.
//
//

import Foundation
import CoreData


extension Job {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Job> {
        return NSFetchRequest<Job>(entityName: "Job")
    }

    @NSManaged public var schematic: Data?
    @NSManaged public var name: String?
    @NSManaged public var jobSheets: NSSet?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for jobSheets
extension Job {

    @objc(addJobSheetsObject:)
    @NSManaged public func addToJobSheets(_ value: JobSheet)

    @objc(removeJobSheetsObject:)
    @NSManaged public func removeFromJobSheets(_ value: JobSheet)

    @objc(addJobSheets:)
    @NSManaged public func addToJobSheets(_ values: NSSet)

    @objc(removeJobSheets:)
    @NSManaged public func removeFromJobSheets(_ values: NSSet)

}

// MARK: Generated accessors for photos
extension Job {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

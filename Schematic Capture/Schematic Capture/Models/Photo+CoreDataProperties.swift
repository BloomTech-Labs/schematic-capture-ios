//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Gi Pyo Kim on 2/6/20.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var name: String?

}

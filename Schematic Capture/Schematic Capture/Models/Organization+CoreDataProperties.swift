//
//  Organization+CoreDataProperties.swift
//  
//
//  Created by Gi Pyo Kim on 2/6/20.
//
//

import Foundation
import CoreData


extension Organization {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Organization> {
        return NSFetchRequest<Organization>(entityName: "Organization")
    }

    @NSManaged public var name: String?
    @NSManaged public var clients: NSSet?

}

// MARK: Generated accessors for clients
extension Organization {

    @objc(addClientsObject:)
    @NSManaged public func addToClients(_ value: Client)

    @objc(removeClientsObject:)
    @NSManaged public func removeFromClients(_ value: Client)

    @objc(addClients:)
    @NSManaged public func addToClients(_ values: NSSet)

    @objc(removeClients:)
    @NSManaged public func removeFromClients(_ values: NSSet)

}

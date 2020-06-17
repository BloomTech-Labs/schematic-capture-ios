//
//  ModelClass.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import CoreData

class Model<T> where T: NSManagedObject {
    
    fileprivate var context: NSManagedObjectContext!
    
    lazy var fetchedResultscontroller: NSFetchedResultsController<T> = { [weak self] in
        
        guard let self = self else {
            fatalError("lazy property has been called after object has been descructed")
        }
        
//        let fetchRequest = NSFetchRequest(entityName: "")
        
        guard let request = T.fetchRequest() as? NSFetchRequest<T> else {
            fatalError("Can't set up NSFetchRequest")
        }
        
        if let parentId = UserDefaults.standard.value(forKey: .selectedRow) as? Int {
            switch request.entityName {
            case EntityNames.project.rawValue:
                request.predicate = NSPredicate(format: "clientId = %@", "\(parentId)")
            case EntityNames.jobSheet.rawValue:
                request.predicate = NSPredicate(format: "projectId = %@", "\(parentId)")
            case EntityNames.component.rawValue:
                print("PARENT ID: ", parentId)
                request.predicate = NSPredicate(format: "jobsheetId = %@", "\(parentId)")
            default:
                break
            }
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let frc = NSFetchedResultsController<T>(fetchRequest: request, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
        }()
}

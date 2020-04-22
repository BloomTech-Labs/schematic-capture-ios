//
//  ProjectsTableViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/7/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData

class ProjectsTableViewController: UITableViewController {
    
    var loginController: LogInController?
    var projectController: ProjectController?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "clientId", ascending: true),
                                         NSSortDescriptor(key: "name", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "clientId", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch() // Fetch the tasks
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as? ProjectTableViewCell else { return UITableViewCell() }

        cell.project = fetchedResultsController.object(at: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

   

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JobSheetSegue" {
            if let jobSheetsTVC = segue.destination as? JobSheetsTableViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                guard let jobSheetsSet = fetchedResultsController.object(at: indexPath).jobSheets,
                    let jobSheets = jobSheetsSet.sortedArray(using: [NSSortDescriptor(key: "id", ascending: true)]) as? [JobSheet] else {
                        print("No jobsheets found in \(fetchedResultsController.object(at: indexPath))")
                        return
                }
                jobSheetsTVC.jobSheets = jobSheets
            }
        }
    }
    

}

extension ProjectsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            return
        }
        
    }
}

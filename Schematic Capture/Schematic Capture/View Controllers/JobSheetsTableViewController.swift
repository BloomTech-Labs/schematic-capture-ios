//
//  JobSheetsTableViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/17/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData

class JobSheetsTableViewController: UITableViewController {
    
    // MARK: - UI Elements
    
    var headerView = HeaderView()
    
    // MARK: - Properties
    
    var dropboxController: DropboxController?
    
    var token: String?
    
    lazy var fetchedResultsController: NSFetchedResultsController<JobSheet> = {
        let fetchRequest: NSFetchRequest<JobSheet> = JobSheet.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "projectId = %@", "\(self.project!.id)")
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()
    
    var project: Project? {
        didSet {
            guard let name = project?.name else { return }
            headerView.setup(viewTypes: .jobsheets, value: [name, "Incomplete (1/1)", "Job Sheets"])
        }
    }
    
    var filteredJobSheets: [JobSheet]?
    
    var userPath: [String]?
    
    // MARK: - View Lifecycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        headerView.searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        headerView.searchDelegate = self
        tableView.tableHeaderView = headerView
        tableView?.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.id)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
        if headerView.searchBar.text != "" {
            return filteredJobSheets?.count ?? 0
        } else if count == 0 {
            tableView.setEmptyView(title: "You don't have any job sheets.", message: "You'll find your assigned job sheets here.")
            return 0
        } else {
            tableView.restore()
            return count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.id, for: indexPath) as? GeneralTableViewCell else { return UITableViewCell() }
        if headerView.searchBar.text != "" {
            if let jobSheet = filteredJobSheets?[indexPath.row] {
                cell.updateViews(viewTypes: .jobsheets, value: jobSheet)
            }
        } else {
            let jobSheet = fetchedResultsController.object(at: indexPath)
            cell.updateViews(viewTypes: .jobsheets, value: jobSheet)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let jobSheet = fetchedResultsController.object(at: indexPath)
        let componentsTableViewViewController = ComponentsTableViewController()
        componentsTableViewViewController.dropboxController = dropboxController
        componentsTableViewViewController.jobSheet = jobSheet
        componentsTableViewViewController.userPath = self.userPath
        componentsTableViewViewController.userPath?.append(jobSheet.name ?? "")
        navigationController?.pushViewController(componentsTableViewViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension JobSheetsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath    = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
}


// MARK: - Search Delegate

extension JobSheetsTableViewController: SearchDelegate {
    func searchDidEnd(didChangeText: String) {
        guard let jobsheets = fetchedResultsController.fetchedObjects else { return }
        self.filteredJobSheets = jobsheets.filter({$0.name!.capitalized.contains(didChangeText.capitalized)})
        tableView.reloadData()
    }
}

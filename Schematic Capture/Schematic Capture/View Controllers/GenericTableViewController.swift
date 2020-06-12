//
//  GenericTableViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData

class GenericTableViewController<T: NSManagedObject, Cell: UITableViewCell>: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var configure: (Cell, T) -> Void
    var selectHandler: (T) -> Void
    var model: Model<T>!
    let headerView = HeaderView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: Model<T>, parentId: String?, title: String, configure: @escaping (Cell, T) -> Void, selectHandler: @escaping (T) -> Void) {
        
        self.configure = configure
        self.selectHandler = selectHandler
        self.model = model

        super.init(style: .plain)
        self.title = title
        model.fetchedResultscontroller.delegate = self
        model.predicate = "\("clientId = %@", "\(parentId)")"
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        headerView.label.text = title
        tableView.tableHeaderView = headerView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(goToSettings))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSettings))
        
        self.tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model?.fetchedResultscontroller.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.fetchedResultscontroller.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let item =  (model?.fetchedResultscontroller.object(at: indexPath))!
        configure(cell, item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = (model?.fetchedResultscontroller.object(at: indexPath))!
        selectHandler(item)
    }
    
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
    
    @objc private func goToSettings() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
}

class Model<T> where T: NSManagedObject {
    
    var predicate: String?
    fileprivate var context: NSManagedObjectContext!
    
    fileprivate lazy var fetchedResultscontroller: NSFetchedResultsController<T> = { [weak self] in
        guard let this = self else {
            fatalError("lazy property has been called after object has been descructed")
        }
        guard let request = T.fetchRequest() as? NSFetchRequest<T> else {
            fatalError("Can't set up NSFetchRequest")
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        request.predicate = NSPredicate(format: self?.predicate ?? "")

        let frc = NSFetchedResultsController<T>(fetchRequest: request, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()
}

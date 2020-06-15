//
//  GenericTableViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData

class GenericTableViewController<T: NSManagedObject, Cell: GeneralTableViewCell>: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    
    // The configuration of the cell, it return a cell and a value
    var configure: (Cell, T) -> Void
    
    /* Triggered when a cell is selected in any instance
     of this TableView Controller */
    var selectHandler: (T) -> Void
    
    /* The model is a generic coredata model,
     created in order to pass diffirent types of model*/
    var model: Model<T>!
    
    /* The headerView of the tableView*/
    let headerView = HeaderView()
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: Model<T>, title: String, configure: @escaping (Cell, T) -> Void, selectHandler: @escaping (T) -> Void) {
        
        self.configure = configure
        self.selectHandler = selectHandler
        self.model = model
        
        super.init(style: .plain)
        setupViews(title: title)
    }
    
    // MARK: - Functions
    
    private func setupViews(title: String) {
        
        self.view.backgroundColor = .systemBackground
        
        model.fetchedResultscontroller.delegate = self
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        headerView.label.text = title
        tableView.tableHeaderView = headerView
        
        let menuButtons = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(goToSettings))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSettings))
        
        navigationItem.rightBarButtonItems = [menuButtons, searchButton]
        self.tableView.register(Cell.self, forCellReuseIdentifier: Cell.id)
    }
    
    
    @objc private func goToSettings() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    // MARK: - Table View Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model?.fetchedResultscontroller.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.fetchedResultscontroller.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.id, for: indexPath) as! Cell
        cell.accessoryType = .disclosureIndicator
        let item =  (model?.fetchedResultscontroller.object(at: indexPath))!
        configure(cell, item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if model.fetchedResultscontroller.fetchRequest.entityName == "JobSheet" {
            print("MODEL IS Jobsheet ")
        }
        
        
        UserDefaults.standard.set(indexPath.row + 1, forKey: .selectedRow)
        let item = (model?.fetchedResultscontroller.object(at: indexPath))!
        selectHandler(item)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
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

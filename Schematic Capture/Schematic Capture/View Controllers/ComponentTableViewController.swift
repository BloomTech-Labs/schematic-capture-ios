//
//  ComponentsTableViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/17/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData
import SwiftyDropbox

class ComponentsTableViewController: UITableViewController {
    
    // MARK: - UI Elements
    
    var headerView = HeaderView()

    // MARK: - Propertiess
    
    var dropboxController: DropboxController?
        
    var jobSheet: JobSheet?
    
    var filteredComponents: [Component]?
    
    var imagePicker: ImagePicker!
    
    var userPath: [String]?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Component> = {
        let fetchRequest: NSFetchRequest<Component> = Component.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "jobSheetId = %@", "\(self.jobSheet!.id)")
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
    
    // MARK: - View Lifecycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        headerView.searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground

        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        headerView.searchDelegate = self
        tableView.tableHeaderView = headerView
        tableView?.register(ComponentTableViewCell.self, forCellReuseIdentifier: ComponentTableViewCell.id)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultsController.sections?[section].numberOfObjects ?? 0

        if headerView.searchBar.text != "" {
            return filteredComponents?.count ?? 0
        } else if count == 0 {
            tableView.setEmptyView(title: "You don't have any components.", message: "You'll find the components here.")
            return 0
        } else {
            tableView.restore()
            return count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ComponentTableViewCell.id, for: indexPath) as? ComponentTableViewCell else { return UITableViewCell() }
        if headerView.searchBar.text != "" {
            if let component = filteredComponents?[indexPath.row] {
                cell.updateViews(component: component)
            }
        } else {
            let component = fetchedResultsController.object(at: indexPath)
            cell.updateViews(component: component)
        }
        cell.dropboxController = dropboxController
        cell.userPath = userPath
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let component = fetchedResultsController.object(at: indexPath)
        let componentDetailsViewController = ComponentDetailsViewController()
        componentDetailsViewController.component = component
        navigationController?.pushViewController(componentDetailsViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
}

// MARK: - ImagePickerDelegate

extension ComponentsTableViewController: ImagePickerDelegate {
    
    // Unannotated image
    func didSelect(image: UIImage?) {
        if image != nil {
            guard let imageData = image?.jpegData(compressionQuality: 1), let componentRow = dropboxController?.selectedComponentRow, let path = self.userPath else { return }
            let component = fetchedResultsController.object(at: IndexPath(row: componentRow, section: 1))
            self.dropboxController?.updateDropbox(imageData: imageData, path: path, componentId: Int(component.id), imageName: "normal")
            let annotationViewController = AnnotationViewController()
            annotationViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: annotationViewController)
            navigationController.modalPresentationStyle = .fullScreen
            annotationViewController.image = image
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

// MARK: - ImageDoneEditingDelegate

extension ComponentsTableViewController: ImageDoneEditingDelegate {
    
    // Annotated Image
    func ImageDoneEditing(image: UIImage?) {
        guard let imageData = image?.jpegData(compressionQuality: 1),
            let componentRow = dropboxController?.selectedComponentRow,
            let path = self.userPath else { return }
        
        var component = fetchedResultsController.object(at: IndexPath(row: componentRow, section: 1))

        component.imageData = imageData
        CoreDataStack.shared.save()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ComponentsTableViewController: NSFetchedResultsControllerDelegate {
    
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

extension ComponentsTableViewController: SelectedCellDelegate {
    func selectedCell(cell: ComponentTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        dropboxController?.selectedComponentRow = indexPath.row
        self.imagePicker.present(from: view)
    }
}

extension ComponentsTableViewController: SearchDelegate {
    func searchDidEnd(didChangeText: String) {
        //self.filteredComponents = components.filter({($0.componentApplication!.capitalized.contains(didChangeText.capitalized))})
        tableView.reloadData()
    }
}

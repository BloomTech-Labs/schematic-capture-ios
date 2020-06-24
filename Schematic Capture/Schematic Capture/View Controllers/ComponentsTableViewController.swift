//
//  ComponentsTableViewController.swift
//  Schematic Capture
//
//  Created by Ufuk Türközü on 22.05.20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData
import SwiftyDropbox

class ComponentsTableViewController: UITableViewController {
    
    // MARK: - UI Elements
    
    var headerView = HeaderView()
    
    // MARK: - Propertiess
    var projectController: ProjectController?
    var dropboxController: DropboxController?
    var imagePicker: ImagePicker!
    
    var token: String?
    
    var userPath: [String]?
    
    var jobSheet: JobSheet?
    
    var filteredComponents: [Component]?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Component> = {
        let fetchRequest: NSFetchRequest<Component> = Component.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "jobsheetId == \(jobSheet!.id)")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.isMovingFromParent) {
            self.dropboxController?.path.removeLast()
        }
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.backgroundColor = .systemBackground
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        
        headerView.searchDelegate = self
        tableView.tableHeaderView = headerView
        headerView.label.text = "Components"
        tableView?.register(ComponentTableViewCell.self, forCellReuseIdentifier: ComponentTableViewCell.id)
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        headerView.secondaryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSchematicVC)))
        headerView.button.addTarget(self, action: #selector(showSchematicVC), for: .touchUpInside)
        headerView.showButton(text: "View Schematic")
    }
    
    @objc private func showSchematicVC() {
        let schematicViewController = SchematicViewController()
        if let link = jobSheet?.schematic {
            schematicViewController.schematicLink = link
            let navigationController = UINavigationController(rootViewController: schematicViewController)
            self.present(navigationController, animated: true, completion: nil)
        } else {
            self.showMessage("There's no schematic for this component.", type: .info)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ComponentTableViewCell.id, for: indexPath) as? ComponentTableViewCell else { return UITableViewCell() }
    
        cell.accessoryType = .disclosureIndicator
        let component = fetchedResultsController.object(at: indexPath)
        print("COMPONENT: ", component)
        
        cell.selecteImageViewAction = { sender in
            UserDefaults.standard.set(component.componentId, forKey: .selectedRow)
            self.imagePicker.present(from: self.view)
        }
        cell.componentImageView.image = UIImage(systemName: "camera")
        cell.updateViews(component: component)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ComponentTableViewCell
        let component = self.fetchedResultsController.object(at: indexPath)
        dropboxController?.selectedComponentRow = indexPath.row
        
        let componentDetailsViewController = ComponentDetailsViewController()
        if let image = cell.componentImageView.image {
            if image != UIImage(systemName: "camera") {
                componentDetailsViewController.image = cell.componentImageView.image
            }
        }
        componentDetailsViewController.projectController = projectController
        componentDetailsViewController.dropboxController = dropboxController
        componentDetailsViewController.component = component
           
        self.navigationController?.pushViewController(componentDetailsViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
    
}
// MARK: - ImagePickerDelegate
extension ComponentsTableViewController: ImagePickerDelegate {
    
    // Unannotated image
    func didSelect(image: UIImage?) {
        if image != nil {
            let row = UserDefaults.standard.integer(forKey: .selectedRow)
            guard let imageData = image?.pngData(),  var path = dropboxController?.path else { return }
            let component = self.fetchedResultsController.object(at: IndexPath(row: row, section: 0))
            path.append("Normal")
            dropboxController?.updateDropbox(imageData: imageData, path: path, imageName: "\(component.componentId ?? "")")
            let annotationViewController = AnnotationViewController()
            annotationViewController.delegate = self as ImageDoneEditingDelegate
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
        let row = UserDefaults.standard.integer(forKey: .selectedRow)
        guard let imageData = image?.pngData(), var path = dropboxController?.path else { return }
        path.append("Annotated")
        guard let component = self.fetchedResultsController.fetchedObjects?.filter({$0.componentId == String(row)}).first else { return }
        self.dropboxController?.updateDropbox(imageData: imageData, path: path, imageName: "\(component.componentId ?? "")")
        component.imageData = imageData
        CoreDataStack.shared.save()
    }
}

extension ComponentsTableViewController: SearchDelegate {
    func searchDidEnd(didChangeText: String) {
        tableView.reloadData()
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
            //tableView.deleteRows(at: [indexPath], with: .automatic)
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

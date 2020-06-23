//
//  GenericTableViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData

class GenericTableViewController<T: NSManagedObject, Cell: GeneralTableViewCell>: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    // MARK: - Properties
    
    // The configuration of the cell, it return a cell and a value
    var configure: (Cell, T) -> Void
    
    /* Triggered when a cell is selected in any instance
     of this TableView Controller */
    var selectHandler: (T) -> Void
    
    /* The model is a generic coredata model,
     created in order to pass diffirent types of model*/
    var model: Model<T>!
    
    var items: [T] = []
    
    /* The headerView of the tableView*/
    let headerView = HeaderView()
    let searchBar = UISearchBar()
    
    var rightBarButtonItems: [UIBarButtonItem]!
    
    var imagePicker: ImagePicker!
    
    var dropboxController: DropboxController?
    let projectController = ProjectController()
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: Model<T>, title: String, configure: @escaping (Cell, T) -> Void, selectHandler: @escaping (T) -> Void) {
        
        self.configure = configure
        self.selectHandler = selectHandler
        self.model = model
        
        super.init(style: .plain)
        setupViews(title: title, model: model)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.isMovingFromParent) {
            self.dropboxController?.path.removeLast()
        }
    }
    
    // MARK: - Functions
    
    private func setupViews(title: String, model: Model<T>) {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        
        self.view.backgroundColor = .systemBackground
        
        model.fetchedResultscontroller.delegate = self
        
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        headerView.label.text = title
        
        tableView.tableHeaderView = headerView
        
        
        if model.fetchedResultscontroller.fetchRequest.entityName == EntityNames.client.rawValue {
            let date = CachedDateFormattingHelper.shared.formatTodayDate()
            headerView.secondaryLabel.text = date
        }
                
//        if model.fetchedResultscontroller.fetchRequest.entityName == EntityNames.component.rawValue {
//            headerView.secondaryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSchematicVC)))
//            headerView.button.addTarget(self, action: #selector(showSchematicVC), for: .touchUpInside)
//            headerView.showButton(text: "View Schematic")
//        }

        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(settingsTapped))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        
        self.rightBarButtonItems = [settingsButton, searchButton]
        navigationItem.rightBarButtonItems = self.rightBarButtonItems
        self.tableView.register(Cell.self, forCellReuseIdentifier: Cell.id)
    }

    @objc private func settingsTapped() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
//    @objc private func showSchematicVC() {
//        let schematicViewController = SchematicViewController()
//        let jobsheet = self.model.fetchedResultscontroller.fetchedObjects?.first as! JobSheet
//        schematicViewController.jobSheet = jobsheet
//        let navigationController = UINavigationController(rootViewController: schematicViewController)
//        self.present(navigationController, animated: true, completion: nil)
//    }
    
    
    
    @objc func searchTapped() {
        self.navigationItem.rightBarButtonItems = []
        self.navigationItem.titleView = searchBar
        navigationItem.hidesBackButton = true
        self.searchBar.sizeToFit()
        let deadline = DispatchTime.now() + .milliseconds(5)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.searchBar.becomeFirstResponder()
        }
    }
    
    @objc func imageViewTapped(sender: UIImageView) {
        self.imagePicker.present(from: sender)
    }
    
    // MARK: - Table View Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model?.fetchedResultscontroller.sections?.count ?? 0 + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return items.count
        } else {
            return model?.fetchedResultscontroller.sections?[section].numberOfObjects ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.id, for: indexPath) as! Cell
        cell.regularImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        if searchBar.text != "" {
            let item = items[indexPath.row]
            self.configure(cell, item)
        } else {
            let item = (model?.fetchedResultscontroller.object(at: indexPath))!
            configure(cell, item)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if model.fetchedResultscontroller.fetchRequest.entityName == EntityNames.jobSheet.rawValue {
            let item = (model?.fetchedResultscontroller.object(at: indexPath))!
            let viewController = ComponentsTableViewController()
            if let jobsheet = item as? JobSheet {
                viewController.jobSheet = jobsheet
            }
            selectHandler(item)
            viewController.dropboxController = self.dropboxController
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let item = (model?.fetchedResultscontroller.object(at: indexPath))!
            selectHandler(item)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItems = rightBarButtonItems
        navigationItem.setHidesBackButton(false, animated: true)
        searchBar.text = ""
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //navigationItem.rightBarButtonItems = rightBarButtonItems
        tableView.reloadData()
        guard let results = model.fetchedResultscontroller.fetchedObjects else { return }
        var searchedItems: [T] = []
        switch model.fetchedResultscontroller.fetchRequest.entityName {
        case EntityNames.client.rawValue:
            guard let clients = results as? [Client] else { return }
            searchedItems = clients.filter({($0.companyName!.capitalized.contains(searchText.capitalized))}) as! [T]
        case EntityNames.project.rawValue:
            guard let projects = results as? [Project] else { return }
            searchedItems = projects.filter({($0.name!.capitalized.contains(searchText.capitalized))}) as! [T]
        case EntityNames.jobSheet.rawValue:
            guard let jobSheets = results as? [JobSheet] else { return }
            searchedItems = jobSheets.filter({($0.name!.capitalized.contains(searchText.capitalized))}) as! [T]
        case EntityNames.component.rawValue:
            guard let components = results as? [Component] else { return }
            searchedItems = components.filter({($0.componentApplication!.capitalized.contains(searchText.capitalized))}) as! [T]
        default: break
        }
        items = searchedItems
        tableView.reloadData()
    }
}

//extension GenericTableViewController: ImagePickerDelegate, ImageDoneEditingDelegate {
    
    // Annotated image
//    func ImageDoneEditing(image: UIImage?) {
//        guard let imageData = image?.jpegData(compressionQuality: 1), let dropboxController = self.dropboxController else { return }
//        let componentRow = dropboxController.selectedComponentRow
//
//
//        let componentId = UserDefaults.standard.string(forKey: .selectedRow)
//                   if let components = model.fetchedResultscontroller.fetchedObjects as? [Component] {
//                       let component = components.filter({$0.componentId == componentId}).first
//
//                        component.imageData = imageData
//                        guard let id = Int(component.componentId ?? ""), var path = self.dropboxController?.path else { return }
//                        path.append("Annotated")
//                        dropboxController.updateDropbox(imageData: imageData, path: path, imageName: "\(id)")
//                        self.projectController.saveToPersistence()
//                        self.tableView.reloadData()
//        }
//
//    }
    
    
//    // Unannotated image
//    func didSelect(image: UIImage?) {
//
//        print("DID SELECTED")
//
//
//
//        if image != nil {
//            guard let imageData = image?.jpegData(compressionQuality: 1), let dropboxController = self.dropboxController else { return }
//            let componentId = UserDefaults.standard.string(forKey: .selectedRow)
//
//
//            if let components = model.fetchedResultscontroller.fetchedObjects as? [Component] {
//
//                let component = components.filter({$0.componentId == componentId}).first
//
//
//                guard let id = component?.id, var path = self.dropboxController?.path else { return }
//                path.append("Normal")
//                dropboxController.updateDropbox(imageData: imageData, path: path, imageName: "\(id)")
//                let annotationViewController = AnnotationViewController()
//                annotationViewController.delegate = self as ImageDoneEditingDelegate
//                let navigationController = UINavigationController(rootViewController: annotationViewController)
//                navigationController.modalPresentationStyle = .fullScreen
//                annotationViewController.image = image
//                self.present(navigationController, animated: true, completion: nil)
//            }
//        }
//    }
//}

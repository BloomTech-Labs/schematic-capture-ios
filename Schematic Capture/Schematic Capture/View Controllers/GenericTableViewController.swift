//
//  GenericTableViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData

class GenericTableViewController<T: NSManagedObject, Cell: UITableViewCell>: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
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
    
    let dropboxController = DropboxController()
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
    
    // MARK: - Table View Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model?.fetchedResultscontroller.sections?.count ?? 0 + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return items.count
        } else {
            tableView.restore()
            return model?.fetchedResultscontroller.sections?[section].numberOfObjects ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: Cell.id) as! Cell
        cell.accessoryType = .disclosureIndicator
        if searchBar.text != "" {
            let item = items[indexPath.row]
            self.configure(cell, item)
        } else {
            let item =  (model?.fetchedResultscontroller.object(at: indexPath))!
            configure(cell, item)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if model.fetchedResultscontroller.fetchRequest.entityName == "JobSheet" {
            let item = model.fetchedResultscontroller.object(at: indexPath)
            let jobsheet = item as! JobSheet
            UserDefaults.standard.set(jobsheet.id, forKey: .selectedRow)
            selectHandler(item)
        } else if model.fetchedResultscontroller.fetchRequest.entityName == "Component"  {
            UserDefaults.standard.set(indexPath.row + 1, forKey: .selectedRow)
            let item = (model?.fetchedResultscontroller.object(at: indexPath))!
            self.showComponentAlert(component: item as! Component)
        } else {
            UserDefaults.standard.set(indexPath.row + 1, forKey: .selectedRow)
            let item = (model?.fetchedResultscontroller.object(at: indexPath))!
            selectHandler(item)
        }
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
        print(searchText)
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
    
    private func showComponentAlert(component: Component) {
        
        let alert = UIAlertController(title: "Component \(component.id)", message: nil, preferredStyle: .actionSheet)
        
        let textView = UITextView()
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let controller = UIViewController()
        
        textView.frame = controller.view.frame
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.text = "Description: \(component.componentApplication ?? "") \n \nManufacturer: \(component.manufacturer ?? "") \nPart #: \(component.partNumber ?? "")\n \nRL Category: \(component.rlCategory ?? "")\n \nRL Number: \(component.rlNumber ?? "")\n \nStock Code: \(component.stockCode ?? "")\n \nElectrical address: \(component.electricalAddress ?? "")\n \nComponent Application: \(component.componentApplication ?? "")"
        controller.view.addSubview(textView)
        
        alert.setValue(controller, forKey: "contentViewController")
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height * 0.8)
        alert.view.addConstraint(height)
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
            // Go to editViewController
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {
            action in
                 // Called when user taps outside
        }))

        present(alert, animated: true, completion: nil)
    }
}

extension GenericTableViewController: ImagePickerDelegate, ImageDoneEditingDelegate {
    
    
    func ImageDoneEditing(image: UIImage?) {
        let componentRow = dropboxController.selectedComponentRow
        guard let imageData = image?.jpegData(compressionQuality: 1), let component = (model?.fetchedResultscontroller.object(at: IndexPath(row: componentRow, section: 0))) as? Component else { return }
        component.imageData = imageData
        
        guard let id = Int(component.componentId ?? "") else { return }
        self.dropboxController.updateDropbox(imageData: imageData, path: [""], componentId: id, imageName: "annotated")
        self.projectController.saveToPersistence()
        self.tableView.reloadData()
    }
    
    
    // Unannotated image
    func didSelect(image: UIImage?) {
        if image != nil {
            guard let imageData = image?.jpegData(compressionQuality: 1) else { return }
            let componentRow = dropboxController.selectedComponentRow
            let component = (model?.fetchedResultscontroller.object(at: IndexPath(row: componentRow, section: 0))) as? Component
            guard let id = Int(component?.componentId ?? "") else { return }
            
            self.dropboxController.updateDropbox(imageData: imageData, path: [""], componentId: id, imageName: "normal")
            let annotationViewController = AnnotationViewController()
            annotationViewController.delegate = self as ImageDoneEditingDelegate
            let navigationController = UINavigationController(rootViewController: annotationViewController)
            navigationController.modalPresentationStyle = .fullScreen
            annotationViewController.image = image
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

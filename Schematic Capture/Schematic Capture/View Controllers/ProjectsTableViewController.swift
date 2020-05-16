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
    
    var authController: AuthorizationController?
    var projectController = ProjectController()
    
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
        
        setupViews()
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
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        self.title = "Projects"
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

/*
 import UIKit
 import WebKit
 import SwiftyDropbox
 
 class HomeViewController: UIViewController, WKUIDelegate {
 
 // MARK: - UI Elements
 
 @IBOutlet weak var downloadProjectsButton: UIButton!
 @IBOutlet weak var viewProjectsButton: UIButton!
 @IBOutlet weak var uploadJobSheetsButton: UIButton! // not implemented
 
 // MARK: - Properties
 
 var loginController: AuthorizationController?
 var projectController = ProjectController()
 var webView: WKWebView!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
 webView.uiDelegate = self
 if let url = Bundle.main.url(forResource: "Pulse-1s-200px", withExtension: "svg") {
 webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
 }
 }
 
 @IBAction func uploadJobSheets(_ sender: Any) {
 DropboxClientsManager.authorizeFromController(UIApplication.shared,
 controller: self,
 openURL: {(url:URL) -> Void in UIApplication.shared.openURL(url)})
 }
 
 @IBAction func downloadSchematics(_ sender: Any) {
 startLoadingScreen()
 
 projectController.downloadAssignedJobs { (error) in
 if let error = error {
 self.stopLoadingScreen()
 DispatchQueue.main.async {
 // TODO: - Show Alert: "Unable to download assigned jobs", subTitle: "\(error)")
 }
 return
 }
 
 // adding these to stop download animation
 self.stopLoadingScreen()
 DispatchQueue.main.async {
 // TODO: - Show Alert
 }
 }
 }
 
 @IBAction func signOut(_ sender: Any) {
 guard let loginController = loginController else { return }
 
 //        loginController.signOut { (error) in
 //            if let error = error {
 //                print("\(error)")
 //                return
 //            }
 //
 //            DispatchQueue.main.async {
 //                if self.presentingViewController != nil {
 //                    self.dismiss(animated: false, completion: {
 //                        self.navigationController!.popToRootViewController(animated: true)
 //                    })
 //                } else {
 //                    self.navigationController!.popToRootViewController(animated: true)
 //                }
 //            }
 //        }
 }
 
 func startLoadingScreen() {
 guard let webView = webView else { return }
 
 DispatchQueue.main.async {
 webView.translatesAutoresizingMaskIntoConstraints = false
 webView.backgroundColor = .clear
 webView.isOpaque = false
 self.view.addSubview(webView)
 
 webView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
 webView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
 webView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
 webView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -15).isActive = true
 }
 }
 
 func stopLoadingScreen() {
 guard let webView = webView else { return }
 DispatchQueue.main.async {
 webView.removeFromSuperview()
 self.webView = nil
 }
 }
 
 }
 */

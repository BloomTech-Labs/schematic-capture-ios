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
    
    // MARK: - UI Elements
    
    var headerView = HeaderView()
    
    var authController: AuthorizationController?
    var projectController: ProjectController?
    
    // The client from the previous ClientsViewController
    var client: Client? {
        didSet {
            fetchProjects()
            headerView.setup(viewTypes: .projects, value: [client!.companyName ?? "", "Projects"])
        }
    }
    
    var token: String?
    var projects = [ProjectRepresentation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        tableView.tableHeaderView = headerView
        tableView?.register(ProjectTableViewCell.self, forCellReuseIdentifier: ProjectTableViewCell.id)
    }
    
    private func fetchProjects() {
        
        guard let id = client?.id, let token = self.token ?? UserDefaults.standard.string(forKey: .token) else { return }
        projectController?.getProjects(with: id, token: token, completion: { result in
            if let projects = try? result.get() as? [ProjectRepresentation] {
                print("PROJECTS: \(projects)")
                self.projects = projects
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                self.projectController?.getJobSheets(with: 1, token: (self.token ?? UserDefaults.standard.string(forKey: .token)) ?? "", completion: { (result) in
                    if let jobsheet = try?  result.get() as? [JobSheet] {
                        print(jobsheet)
                    }
                })
            }
        })
    }
}


// MARK: - Table view data source

extension ProjectsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        //return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projects.count
       // return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.id, for: indexPath) as? ProjectTableViewCell else { return UITableViewCell() }
        let project = self.projects[indexPath.row]
        cell.project = project
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

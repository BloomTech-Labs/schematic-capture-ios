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
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        view.hidesWhenStopped = true
        return view
    }()
    
    // MARK: - Properties
    
    var projectController: ProjectController?
    var token: String?
    // The client from the previous ClientsViewController
    var client: Client? {
        didSet {
            fetchProjects()
        }
    }
   
    var projects = [ProjectRepresentation]()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Projects", style: .plain, target: nil, action: nil)
        fetchProjects()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
                
        indicator.layer.position.y = view.layer.position.y
        indicator.layer.position.x = view.layer.position.x
        indicator.startAnimating()

        tableView?.backgroundColor = .systemBackground
        tableView?.separatorStyle = .none
        tableView?.addSubview(indicator)
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        tableView.tableHeaderView = headerView
        tableView?.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.id)
    }
    
    // MARK: - Functions
    
    private func fetchProjects() {
        
        guard let id = client?.id, let token = self.token ?? UserDefaults.standard.string(forKey: .token) else { return }
        projectController?.getProjects(with: id, token: token, completion: { result in
            if let projects = try? result.get() as? [ProjectRepresentation] {
                self.projects = projects
                DispatchQueue.main.async {
                    let incompletedProjectCount = projects.filter({!$0.completed!}).count
                    let totalCount = projects.count
                    self.headerView.setup(viewTypes: .projects, value: [self.client!.companyName ?? "", "Incomplete (\(incompletedProjectCount)/\(totalCount))", "Projects",])
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
        })
    }
}


// MARK: - Table view data source

extension ProjectsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if projects.count == 0 {
            tableView.setEmptyView(title: "You don't have any projects.", message: "You'll find your assigned projects here.")
            return 0
        } else {
            tableView.restore()
            return projects.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.id, for: indexPath) as? GeneralTableViewCell else { return UITableViewCell() }
        let project = self.projects[indexPath.row]
        cell.updateViews(viewTypes: .projects, value: project)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let project = self.projects[indexPath.row]
        let jobSheetsTableViewViewController = JobSheetsTableViewController()
        jobSheetsTableViewViewController.projectController = projectController
        jobSheetsTableViewViewController.project = project
        jobSheetsTableViewViewController.token = token
        navigationController?.pushViewController(jobSheetsTableViewViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

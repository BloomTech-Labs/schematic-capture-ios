//
//  JobSheetsTableViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/17/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class JobSheetsTableViewController: UITableViewController {
    
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
    
    var project: ProjectRepresentation? {
        didSet {
            fetchJobSheets()
            guard let name = project?.name else { return }
            headerView.setup(viewTypes: .jobsheets, value: [name, "Job Sheets"])
        }
    }
    
    var jobSheets: [JobSheetRepresentation]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchJobSheets()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        indicator.layer.position.y = view.layer.position.y
        indicator.layer.position.x = view.layer.position.x
        indicator.startAnimating()
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.addSubview(indicator)
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        tableView.tableHeaderView = headerView
        tableView?.register(JobSheetTableViewCell.self, forCellReuseIdentifier: JobSheetTableViewCell.id)
    }
    
    // MARK: - Functions
    
    private func fetchJobSheets() {
        guard let id = project?.id, let token = self.token ?? UserDefaults.standard.string(forKey: .token) else { return }
        
        projectController?.getJobSheets(with: Int(id), token: token, completion: { results in
            
            if let jobSheets = try? results.get() as? [JobSheetRepresentation] {
                print("JOBSHEETS: \(jobSheets)")
                self.jobSheets = jobSheets
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobSheets?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JobSheetTableViewCell.id, for: indexPath) as? JobSheetTableViewCell else { return UITableViewCell() }
        
        cell.jobSheet = jobSheets?[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let jobSheet = self.jobSheets?[indexPath.row]
        let expyTableViewViewController = ExpyTableViewController()
//        expyTableViewViewController.projectController = projectController
//        expyTableViewViewController.jobSheet = jobSheet
//        expyTableViewViewController.token = token
        navigationController?.pushViewController(expyTableViewViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
}

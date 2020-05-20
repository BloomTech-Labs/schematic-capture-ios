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
            headerView.setup(viewTypes: .jobsheets, value: [name, "Incomolete (1/3)", "Job Sheets"])
        }
    }
    
    var jobSheets: [JobSheetRepresentation]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var filteredJobSheets: [JobSheetRepresentation]?
    
    // MARK: - View Lifecycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        headerView.searchBar.resignFirstResponder()
    }
    
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
        headerView.searchDelegate = self
        tableView.tableHeaderView = headerView
        tableView?.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.id)
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
                    self.indicator.stopAnimating()
                }
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if headerView.searchBar.text != "" {
            return filteredJobSheets?.count ?? 0
        } else if jobSheets?.count == 0 {
            tableView.setEmptyView(title: "You don't have any job sheets.", message: "You'll find your assigned job sheets here.")
            return 0
        } else {
            tableView.restore()
            return jobSheets?.count ?? 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralTableViewCell.id, for: indexPath) as? GeneralTableViewCell else { return UITableViewCell() }
        
        if headerView.searchBar.text != "" {
            let jobSheet = filteredJobSheets?[indexPath.row]
            cell.updateViews(viewTypes: .jobsheets, value: jobSheet)
        } else {
            let jobSheet = jobSheets?[indexPath.row]
            cell.updateViews(viewTypes: .jobsheets, value: jobSheet)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let jobSheet = self.jobSheets?[indexPath.row]
        let componentsTableViewViewController = ComponentsTableViewController()
        componentsTableViewViewController.projectController = projectController
        componentsTableViewViewController.jobSheet = jobSheet
        componentsTableViewViewController.token = token
        navigationController?.pushViewController(componentsTableViewViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
}

extension JobSheetsTableViewController: SearchDelegate {
    func searchDidEnd(didChangeText: String) {
        self.filteredJobSheets = jobSheets?.filter({$0.name.capitalized.contains(didChangeText.capitalized)})
        tableView.reloadData()
    }
}

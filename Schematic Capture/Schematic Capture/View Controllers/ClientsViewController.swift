//
//  ClientsViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/15/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class ClientsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    var tableView: UITableView!
    var headerView: ClientHeaderView!
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        view.hidesWhenStopped = true
        return view
    }()

    
    // MARK: - Properties
    
    var clients = [Client]()
    var projectController = ProjectController()
    
    var token: String? {
        didSet {
            fetchClients()
        }
    }
    
    private let heightForHeader: CGFloat = 30.0
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchClients()
    }
    
    // MARK: - Functions
    
    func setupUI() {
        
        self.title = "Schematic Capture"
        view.backgroundColor = .systemBackground
        
        indicator.layer.position.y = view.layer.position.y
        indicator.layer.position.x = view.layer.position.x
        
        indicator.startAnimating()
        view.addSubview(indicator)
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(ClientTableViewCell.self, forCellReuseIdentifier: ClientTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        
        headerView = ClientHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
    }
    
    
    func fetchClients() {
        guard let token = token ?? UserDefaults.standard.string(forKey: .token) else { return }
        projectController.getClients(token: token) { result in
            if let clients = try? result.get() as? [Client] {
                DispatchQueue.main.async {
                    print("CLIENTS: \(clients.count)")
                    self.clients = clients
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: TableView Delegate/Datasource

extension ClientsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: ClientTableViewCell.id, for: indexPath) as? ClientTableViewCell {
            let client = self.clients[indexPath.row]
            cell.client = client
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        heightForHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        heightForHeader
    }
}

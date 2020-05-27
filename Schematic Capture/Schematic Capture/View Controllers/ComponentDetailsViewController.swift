//
//  ComponentDetailsViewController.swift
//  Schematic Capture
//
//  Created by Ufuk Türközü on 21.05.20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ComponentDetailsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    var tableView: UITableView!
    var headerView = HeaderView()
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        view.hidesWhenStopped = true
        return view
    }()
    
    
    // MARK: - Properties
    
    var component: ComponentRepresentation? {
        didSet {
            headerView.setup(viewTypes: .componentDetails, value: [
                (component?.componentDescription ?? ""), "Details", ""
            ])
            updateViews()
        }
    }
    
    var details = [String : String]()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Functions
    
    private func setupViews() {
        self.title = "Schematic Capture"
        view.backgroundColor = .systemBackground
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.addSubview(indicator)
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
    }
    
    func updateViews() {
        let details: [String : String] = [
            "Description:" : component?.componentDescription ?? "",
            "Manufacturer:" : component?.manufacturer ?? "",
            "Part #:" : component?.partNumber ?? "",
            "RL Category:" : component?.rlCategory ?? "",
            "RL Number:" : component?.rlNumber ?? "",
            "Stock Code:" : component?.stockCode ?? "",
            "Electrical Address:" : component?.electricalAddress ?? "",
            "Reference Tag:" : component?.referenceTag ?? "",
            "Settings:" : component?.settings ?? "",
            "Resources:" : component?.resources ?? "",
            "Cutsheet:" : component?.cutSheet ?? "",
            "Store's Part #:" : component?.storePartNumber ?? "",
            "Notes:" : component?.custom ?? "",
        ]
        self.details = details
    }
}

extension ComponentDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var keys:[String] {
            get{
                return Array(details.keys)
            }
        }
        let key = keys[indexPath.row]
        let value = details[key]
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = value
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var keys:[String] {
            get{
                return Array(details.keys)
            }
        }
        let key = keys[indexPath.row]
        let value = details[key]
        
        let editCoponentDetailViewController = EditCoponentDetailViewController()
        //editCoponentDetailViewController.value = detail
        navigationController?.pushViewController(editCoponentDetailViewController, animated: true)
    }
}

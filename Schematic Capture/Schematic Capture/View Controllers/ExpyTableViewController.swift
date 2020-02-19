//
//  ExpyTableViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/17/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import ExpyTableView

class ExpyTableViewController: UIViewController {
    
    @IBOutlet weak var expandableTableView: ExpyTableView!
    
    var components: [Component]? {
        didSet {
            if !components!.isEmpty,
                let jobSheet = components![0].ownedJobSheet {
                navigationController?.title = jobSheet.name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        expandableTableView.dataSource = self
        expandableTableView.delegate = self
        
        expandableTableView.rowHeight = UITableView.automaticDimension
        expandableTableView.estimatedRowHeight = 44
        
        expandableTableView.expandingAnimation = .fade
        expandableTableView.collapsingAnimation = .fade
        
        expandableTableView.tableFooterView = UIView()
        
        expandableTableView.reloadData()
    }
}

extension ExpyTableViewController: ExpyTableViewDataSource {
    
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return components?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ComponentMainCell") as? ComponentMainTableViewCell else { return UITableViewCell() }
        
        cell.component = components?[section]
        cell.showSeparator()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ComponentDetailCell") as? ComponentDetailTableViewCell else { return UITableViewCell() }
        cell.component = components?[indexPath.section]
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    

}

extension ExpyTableViewController: ExpyTableViewDelegate {
    
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
        
    }
}

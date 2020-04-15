//
//  JobSheetsTableViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/17/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class JobSheetsTableViewController: UITableViewController {
    

    var jobSheets: [JobSheet]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobSheets?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobSheetCell", for: indexPath) as? JobSheetTableViewCell else { return UITableViewCell() }

        cell.jobSheet = jobSheets?[indexPath.row]

        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ComponentSegue" {
            if let expyTVC = segue.destination as? ExpyTableViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                // Pass components array and schematic pdf data
                guard let componentsSet = jobSheets?[indexPath.row].components,
                    let components = componentsSet.sortedArray(using: [NSSortDescriptor(key: "id", ascending: true)]) as? [Component]
//                    let schematicData = jobSheets?[indexPath.row].schematicData
                    else {
//                        print("No components found in \(String(describing: jobSheets?[indexPath.row]))")
                        return
                }
                expyTVC.components = components
                //expyTVC.schematicData = schematicData // blocking out schematic data logic
            }
        }
    }
    

}

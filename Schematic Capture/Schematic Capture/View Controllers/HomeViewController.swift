//
//  HomeViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var loginLabel: UILabel!
    
    var loginController: LogInController?
    var projectController = ProjectController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func downloadSchematics(_ sender: Any) {
        projectController.downloadAssignedJobs { (error) in
            if let error = error {
                // show alert
                print(error)
                return
            }
            
            self.projectController.downloadSchematics { (error) in
                if let error = error {
                    // show alert
                    print(error)
                    return
                }
            }
        }
    }
    
    
     

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProjectSegue" {
            if let projectsTableVC = segue.destination as? ProjectsTableViewController {
                projectsTableVC.loginController = loginController
                projectsTableVC.projectController = projectController
            }
        }
    }
    

}

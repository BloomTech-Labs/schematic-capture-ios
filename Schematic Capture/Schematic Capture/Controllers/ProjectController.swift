//
//  ProjectController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

class ProjectController {
    
    var bearer: Bearer?
    var user: User?
    var projects: [Project] = []
    
    //    private let loginBaseURL = URL(string: "https://sc-be-production.herokuapp.com/api")!
    private let loginBaseURL = URL(string: "https://sc-be-staging.herokuapp.com/api")!
    
    // Download assigned jobs (get client, project, job, csv as json)
    
    // Download schematic from firebase storage
    
    // Upload jobs in core data (check the status of the jobs)
    
}

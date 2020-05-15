//
//  Enum.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/15/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation


// Urls for all Heroku operations
enum Urls: String {
    case logInUrl = "https://schematiccapture-master.herokuapp.com/api/auth/login"
    case clientsUrl = "https://schematiccapture-master.herokuapp.com/api/clients"
    case projectsUrl = "https://schematiccapture-master.herokuapp.com/api/clients/"
    //https://schematiccapture-master.herokuapp.com/api/clients/:id/projects
    case jobSheetsUrl = "https://schematiccapture-master.herokuapp.com//api/jobsheets/assigned"
    case componentsUrl = "https://schematiccapture-master.herokuapp.com/api/jobsheets/:id/components"
}

enum Keys: String {
    case dropbox = "t5i27y2t3fzkiqj"
}

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
    case logInUrl = "https://schematic-capture.herokuapp.com/api/auth/login"
    case clientsUrl = "https://schematic-capture.herokuapp.com/api/clients"
    case jobSheetsUrl = "https://schematic-capture.herokuapp.com/api/projects"
    case componentsUrl = "https://schematic-capture.herokuapp.com/api/jobsheets"
}

enum Keys: String {
    case dropbox = "t5i27y2t3fzkiqj"
}

enum Shapes: String {
    case circle = "circle"
    case arrow = "arrow.left"
    case square = "square"
}

enum EntityNames: String {
    case client = "Client"
    case project = "Project"
    case jobSheet = "JobSheet"
    case component = "Component"
}

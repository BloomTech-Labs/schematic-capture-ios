//
//  ProjectRepresentation.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/13/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

struct ProjectRepresentation: Codable {
    let id: Int
    var name: String
    var jobSheets: [JobSheetRepresentation]?
    let clientId: Int
   // var assignedStatus:Bool
    var completed:Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case jobSheets = "jobsheet"
        case clientId
        //case assignedStatus
        case completed
    }
}

//
//  ProjectRepresentation.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/13/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

struct ProjectRepresentation: Codable {
    let id: Int
    var name: String?
    var jobsheets: [JobSheetRepresentation]?
    let clientId: Int?
    var completed: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case jobsheets = "jobsheet"
        case clientId
        case completed
    }
}

//
//  JobSheetRepresentation.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/13/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

struct JobSheetRepresentation: Codable {
    let id: Int
    var name: String
    var components: [ComponentRepresentation]?
    var schematicData: Data?
    var schematicName: String?
    var updatedAt: String
    var status: String
    let projectId: Int
    var userEmail:String?
    var completed:Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case components
        case schematicData
        case schematicName
        case updatedAt
        case status
        case projectId
        case userEmail
        case completed 
    }
}

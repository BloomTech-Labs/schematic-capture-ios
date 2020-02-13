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
    var schematic: Data?
    var photos: [PhotoRepresentation]?
    var updatedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case components
        case schematic
        case photos
        case updatedAt
    }
}

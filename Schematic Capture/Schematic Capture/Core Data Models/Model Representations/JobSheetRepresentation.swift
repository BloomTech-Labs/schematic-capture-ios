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
    var schematic: String?
    var updatedAt: String
    var status: String
    let projectId: Int
    var userEmail:String?
    var completed: Bool
    var components: [ComponentRepresentation]?
}



extension JobSheetRepresentation: Equatable {
    static func == (lhs: JobSheetRepresentation, rhs: JobSheetRepresentation) -> Bool {
        lhs.id != rhs.id
    }
}


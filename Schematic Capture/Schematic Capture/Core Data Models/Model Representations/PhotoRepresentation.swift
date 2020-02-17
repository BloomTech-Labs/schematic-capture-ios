//
//  PhotoRepresentation.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/13/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

struct PhotoRepresentation: Codable {
    var name: String
    var imageData: Data
    
    private enum CodingKeys: String, CodingKey {
        case name
        case imageData
    }
}

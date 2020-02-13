//
//  ComponentRepresentation.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

struct ComponentRepresentation: Codable {
    let componentId: String
    var manufacturer: String?
    var partNumber: String?
    var rlCategory: String?
    var rlNumber: String?
    var stockCode: String?
    var electricalAddress: String?
    var componentApplication: String?
    var referenceTag: String?
    var settings: String?
    var image: String?
    var resources: String?
    var cutSheet: String?
    var maintenanceVideo: String?
    var storePartNumber: String?
    var status: String
    
    private enum CodingKeys: String, CodingKey {
        case componentId
        case manufacturer
        case partNumber
        case rlCategory
        case rlNumber
        case stockCode
        case electricalAddress
        case componentApplication
        case referenceTag
        case settings
        case image
        case resources
        case cutSheet
        case maintenanceVideo
        case storePartNumber
        case status
    }
}

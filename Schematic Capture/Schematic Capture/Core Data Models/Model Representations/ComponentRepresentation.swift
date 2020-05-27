//
//  ComponentRepresentation.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

struct ComponentRepresentation: Codable {
    let id: Int
    let componentId: String?
    var rlCategory: String?
    var rlNumber: String?
    var componentDescription: String?
    var manufacturer: String?
    var partNumber: String?
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
    var custom: String?
//    let jobSheetId: Int
    var photo: PhotoRepresentation?
    
}

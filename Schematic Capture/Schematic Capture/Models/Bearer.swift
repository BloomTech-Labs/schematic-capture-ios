//
//  Bearer.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let token: String
}

private enum CodingKeys:String, CodingKey {
    case token
}

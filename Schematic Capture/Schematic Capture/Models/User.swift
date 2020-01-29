//
//  User.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/27/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let token: String
}

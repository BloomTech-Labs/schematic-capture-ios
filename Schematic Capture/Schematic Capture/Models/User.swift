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
    let phone: String
    let inviteToken: String
    
    private enum CodingKeys: String, CodingKey {
        case email
        case password
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case inviteToken = "invite_token"
    }
}



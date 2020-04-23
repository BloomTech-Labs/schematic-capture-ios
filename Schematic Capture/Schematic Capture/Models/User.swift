//
//  User.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/27/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

// Add question:String attribute to User

import Foundation



struct Role: Codable {
    let id: Int
    let name: String
}

struct User: Codable {
    var email: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    var inviteToken: String?
    var role: Role?
    var id: String?
    var username:String?
    

    
    private enum CodingKeys: String, CodingKey {
        case email
        case password
        case firstName
        case lastName
        case phone
        case inviteToken
        case role
        case id
        case username
    }
    

}



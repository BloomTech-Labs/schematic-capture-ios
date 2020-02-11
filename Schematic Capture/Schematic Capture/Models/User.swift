//
//  User.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/27/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

struct Organization: Codable {
    let id: Int
    let name: String
    let phone: String?
    let street: String?
    let city: String?
    let zip: String?
}

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
    var organizations: [Organization]
    var roleId: Int?
    var role: [Role]
    var id: String?
    
    /// Initializer for log in
    init(email: String, password: String) {
        self.email = email
        self.password = password
        self.firstName = nil
        self.lastName = nil
        self.phone = nil
        self.inviteToken = nil
        self.organizations = []
        self.roleId = nil
        self.role = []
        self.id = nil
    }
    
    /// Initializer for sign up
    init(email: String, password: String, firstName: String, lastName: String, phone: String, inviteToken: String) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.inviteToken = inviteToken
        self.organizations = []
        self.roleId = nil
        self.role = []
        self.id = nil
    }
    
    /// Initializer for Google sign up
    init(firstName: String, lastName: String, phone: String?, inviteToken: String?) {
        self.email = nil
        self.password = nil
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.inviteToken = inviteToken
        self.organizations = []
        self.role = []
        self.id = nil
    }
    
    /// Initializer for Google sign in
    init(email: String, firstName: String, lastName: String, phone: String, organizations: [Organization], role: [Role]) {
        self.email = email
        self.password = nil
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.inviteToken = nil
        self.organizations = organizations
        self.role = role
        self.id = nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case email
        case password
        case firstName
        case lastName
        case phone
        case inviteToken
        case organizations
        case role
        case id
    }
}



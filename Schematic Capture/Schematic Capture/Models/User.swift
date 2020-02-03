//
//  User.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/27/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

struct User: Codable {
    var email: String?
    var password: String?
    var confirmPassword: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    var inviteToken: String?
    var organizationID: Int?
    var organization: String?
    var roleID: Int?
    var role: String?
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        self.confirmPassword = nil
        self.firstName = nil
        self.lastName = nil
        self.phone = nil
        self.inviteToken = nil
        self.organizationID = nil
        self.organization = nil
        self.roleID = nil
        self.role = nil
    }
    
    init(email: String, password: String, confirmPassword: String, firstName: String, lastName: String, phone: String, inviteToken: String) {
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.inviteToken = inviteToken
        self.organizationID = nil
        self.organization = nil
        self.roleID = nil
        self.role = nil
    }
    
    init(firstName: String, lastName: String, phone: String?, inviteToken: String?) {
        self.email = nil
        self.password = nil
        self.confirmPassword = nil
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.inviteToken = inviteToken
        self.organizationID = nil
        self.organization = nil
        self.roleID = nil
        self.role = nil
    }
    
    init(email: String, firstName: String, lastName: String, phone: String, organizationID: Int, organization: String, roleID: Int, role: String) {
        self.email = email
        self.password = nil
        self.confirmPassword = nil
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.inviteToken = nil
        self.organizationID = organizationID
        self.organization = organization
        self.roleID = roleID
        self.role = role
    }
    
    private enum CodingKeys: String, CodingKey {
        case email
        case password
        case confirmPassword
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case inviteToken = "invite_token"
        case organizationID = "organization_id"
        case organization
        case roleID = "role_id"
        case role
    }
}



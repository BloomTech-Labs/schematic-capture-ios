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
    var organizationId: Int?
    var organization: String?
    var roleId: Int?
    var role: String?
    var idToken: String?
    var id: String?
    
    /// Initializer for log in
    init(email: String, password: String) {
        self.email = email
        self.password = password
        self.confirmPassword = nil
        self.firstName = nil
        self.lastName = nil
        self.phone = nil
        self.inviteToken = nil
        self.organizationId = nil
        self.organization = nil
        self.roleId = nil
        self.role = nil
        self.idToken = nil
        self.id = nil
    }
    
    /// Initializer for sign up
    init(email: String, password: String, confirmPassword: String, firstName: String, lastName: String, phone: String, inviteToken: String) {
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.inviteToken = inviteToken
        self.organizationId = nil
        self.organization = nil
        self.roleId = nil
        self.role = nil
        self.idToken = nil
        self.id = nil
    }
    
    /// Initializer for Google sign up
    init(firstName: String, lastName: String, phone: String?, inviteToken: String?, idToken: String) {
        self.email = nil
        self.password = nil
        self.confirmPassword = nil
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.inviteToken = inviteToken
        self.organizationId = nil
        self.organization = nil
        self.roleId = nil
        self.role = nil
        self.idToken = idToken
        self.id = nil
    }
    
    /// Initializer for Google sign in
    init(email: String, firstName: String, lastName: String, phone: String, organizationId: Int, organization: String, roleId: Int, role: String) {
        self.email = email
        self.password = nil
        self.confirmPassword = nil
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.inviteToken = nil
        self.organizationId = organizationId
        self.organization = organization
        self.roleId = roleId
        self.role = role
        self.idToken = nil
        self.id = nil
    }
    
    ///Initializer for core data
//    init(email: String, firstName: String, lastName: String, phone: String, organizationId: Int16, organization: String, roleId: Int16, role: String, idToken: String, id: String) {
//        self.email = email
//        self.password = nil
//        self.confirmPassword = nil
//        self.firstName = firstName
//        self.lastName = lastName
//        self.phone = phone
//        self.inviteToken = nil
//        self.organizationId = Int(organizationId)
//        self.organization = organization
//        self.roleId = Int(roleId)
//        self.role = role
//        self.idToken = idToken
//        self.id = id
//    }
    
    private enum CodingKeys: String, CodingKey {
        case email
        case password
        case confirmPassword
        case firstName
        case lastName
        case phone
        case inviteToken
        case organizationId
        case organization
        case roleId
        case role
        case idToken
        case id
    }
}



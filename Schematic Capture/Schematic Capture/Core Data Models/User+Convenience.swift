//
//  User+Convenience.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/10/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    var userRepresentation: User? {
        
        guard let email = email,
            let firstName = firstName,
            let lastName = lastName,
            let phone = phone,
            let organization = organization,
            let role = role,
            let idToken = idToken,
            let id = id else { return nil}
        
        return User(email: email, firstName: firstName, lastName: lastName, phone: phone, organizationId: organizationId, organization: organization, roleId: roleId, role: role, idToken: idToken, id: id)
        
    }
    
    @discardableResult convenience init(email: String?, password: String?, confirmPassword: String?, firstName: String?, lastName: String?, phone: String?, inviteToken: String?, organizationId: Int?, organization: String?, roleId: Int?, role: String?, idToken: String?, id: String?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.organizationId = organizationId != nil ? Int16(organizationId!) : -1
        self.organization = organization
        self.roleId = roleId != nil ? Int16(roleId!) : -1
        self.role = role
        self.idToken = idToken
        self.id = id
    }
    
    @discardableResult convenience init?(userRepresentation: User, context: NSManagedObjectContext) {
        
        guard let email = userRepresentation.email,
            let firstName = userRepresentation.firstName,
            let lastName = userRepresentation.lastName,
            let phone = userRepresentation.phone,
            let organizationId = userRepresentation.organizationId,
            let organization = userRepresentation.organization,
            let roleId = userRepresentation.roleId,
            let role = userRepresentation.role,
            let idToken = userRepresentation.idToken,
            let id = userRepresentation.id else { return nil}
        
        self.init(email: email, password: nil, confirmPassword: nil, firstName: firstName, lastName: lastName, phone: phone, inviteToken: nil, organizationId: organizationId, organization: organization, roleId: roleId, role: role, idToken: idToken, id: id, context: context)
    }
}

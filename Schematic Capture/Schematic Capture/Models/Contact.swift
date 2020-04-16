//
//  Contact.swift
//  Schematic Capture
//
//  Created by Lambda_School_Loaner_219 on 4/8/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
struct Contact {
   var id:Int
    var clientID:Int
    var firstName:String
    var lastName:String
    var phone:String
    var email:String
    
}
private enum CodingKeys:String, CodingKey {
    case id
    case clientID
    case firstName
    case lastName
    case phone
    case email
}

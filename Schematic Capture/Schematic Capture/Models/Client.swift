//
//  Client.swift
//  Schematic Capture
//
//  Created by Lambda_School_Loaner_219 on 4/8/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
struct Client{
    var id:Int
    var companyName:String
    var phone:String
    var street:String
    var city:String
    var state:String
    var zip:String
}

private enum CodingKeys:String, CodingKey {
    case id
    case companyName
    case phone
    case street
    case city
    case state
    case zip 
}

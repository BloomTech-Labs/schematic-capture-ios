//
//  TechClient.swift
//  Schematic Capture
//
//  Created by Lambda_School_Loaner_219 on 4/8/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
struct TechClient: Codable {
    var id: Int
    var clientID:Int
    var techID:Int
    
}

private enum CodingKeys:String, CodingKey {
    case id
    case clientID
    case techID 
}

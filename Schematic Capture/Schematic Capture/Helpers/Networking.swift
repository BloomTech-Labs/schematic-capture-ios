//
//  Networking.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum HeaderNames: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

enum NetworkingError: Error, Equatable {
    static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
    
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode(Int)
    case statusCodeMessage(String)
    case badDecode
    case badEncode
    case noRepresentation
    case needRegister
    case error(String)
}

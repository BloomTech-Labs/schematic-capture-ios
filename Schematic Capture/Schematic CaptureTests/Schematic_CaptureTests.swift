//
//  Schematic_CaptureTests.swift
//  Schematic CaptureTests
//
//  Created by Gi Pyo Kim on 1/23/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import XCTest
import Firebase
import FirebaseStorage
@testable import Schematic_Capture

struct AsyncOperation<Value> {
    let queue: DispatchQueue = .main
    let closure: () -> Value

    func perform(then handler: @escaping (Value) -> Void) {
        queue.async {
            let value = self.closure()
            handler(value)
        }
    }
}

class Schematic_CaptureTests: XCTestCase {
    var loginController = LogInController()
    var projectController = ProjectController()
        

}

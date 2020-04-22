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
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let user = User(password: "Testing123!", username: "bob_johnson@lambdaschool.com")
        let bearer = Bearer?.self
        let expectation = self.expectation(description: "loginController")
        
        loginController.logIn(username: (user.username)!, password: user.password!, completion:  { (error) in
            if let error = error {
                XCTFail("\(error)")
                return
            }
            else {
                expectation.fulfill()
            }
            
            
           
        
 
        
} )
         wait(for:[expectation], timeout:10)
}
    
   func testLogIn(){
    let bearer = Bearer?.self
    let user = User(password: "Testing123!", username: "bob_johnson@lambdaschool.com")
    XCTAssert(user.username == "bob_johnson@lambdaschool.com")
   XCTAssertNotNil(bearer)
    }
    
    func testSignOut(){
        let expectation = self.expectation(description: "Logged out succesfully")
        loginController.signOut(completion: { (error)
            in
            if let error = error {
                XCTFail("\(error)")
                return
            }
            else {
                expectation.fulfill()
            }
            
            
            } )
        wait(for:[expectation], timeout:10)
        
    }
}

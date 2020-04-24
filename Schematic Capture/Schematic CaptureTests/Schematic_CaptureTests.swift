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
        let bearer = Bearer(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6InRpRFRmZU5GMUtjRWtXOTdnUExJcEc4NWl1YjIiLCJwYXNzd29yZCI6MSwiZW1haWwiOiJib2Jfam9obnNvbkBsYW1iZGFzY2hvb2wuY29tIiwicm9sZUlkIjoiVGVzdGluZzEyMyEiLCJpYXQiOjE1ODc1NzY2ODIsImV4cCI6MTU4NzY2MzA4Mn0.Ab_OLV463UTVY4gDvwTZt3orBOmBYGgEKPtDEWRVdUA")
   
        let expectation = self.expectation(description: "loginController")
        
        
        //MARK: Test LoginController
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
    
  
    
    //MARK:Test ProjectController
    
 
       
    

    
    
    func testDownloadAssignedJobs() {
                    self.projectController.bearer = Bearer(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6InRpRFRmZU5GMUtjRWtXOTdnUExJcEc4NWl1YjIiLCJwYXNzd29yZCI6MSwiZW1haWwiOiJib2Jfam9obnNvbkBsYW1iZGFzY2hvb2wuY29tIiwicm9sZUlkIjoiVGVzdGluZzEyMyEiLCJpYXQiOjE1ODc1NzY2ODIsImV4cCI6MTU4NzY2MzA4Mn0.Ab_OLV463UTVY4gDvwTZt3orBOmBYGgEKPtDEWRVdUA")
        let expectation = self.expectation(description: "Downloading assigned jobs succesfully")
        projectController.downloadAssignedJobs(completion: { error in

                
                if let error = error  {
                    if error != NetworkingError.badDecode {
                   
                    XCTFail()
                    print(error)
                    return
                }
                else {
                    expectation.fulfill()
                    
                
               
                    
                }
                
                 
                }
            
        }
            
           
        
        
        
   )
        
        wait(for:[expectation], timeout:10)
    }
    

}

//
//  Schematic_CaptureTests.swift
//  Schematic CaptureTests
//
//  Created by Gi Pyo Kim on 1/23/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import XCTest
@testable import Schematic_Capture

class Schematic_CaptureTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSignUpDecode() {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "signUpJSON", withExtension: "json")
        let data = try! Data(contentsOf: fileUrl!)
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            XCTAssertNotNil(user)
            let token = try JSONDecoder().decode(Bearer.self, from: data)
            XCTAssertNotNil(token)
        }catch {
            XCTFail("\(error)")
        }
    }

}

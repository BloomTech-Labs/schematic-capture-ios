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
        let user = User(email: "bob_johnson@lambdaschool.com", password: "testing123!")
        let expectation = self.expectation(description: "loginController")
        
        loginController.logIn(with: user) { (error) in
            if let error = error {
                XCTFail("\(error)")
                return
            }
            if self.loginController.bearer == nil {
                XCTFail("No bearer")
                return
            }
            self.projectController.bearer = self.loginController.bearer
            self.projectController.user = self.loginController.user
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(loginController.bearer)
    }
    
//    func testDownloadSchematicsPDF() {
//        let listAll = expectation(description: "List All")
//        let getData = expectation(description: "Get Data")
//
//        let maxSize: Int64 = 1073741824 // 1GB
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        var pdfRef: String?
//        let schematicRef = storageRef.child("1")
//            .child("1")
//            .child("1")
//            .child("1")
//        schematicRef.listAll { (listResult, error) in
//            if let error = error {
//                XCTFail("\(error)")
//                return
//            }
//            let listFullPaths = listResult.items.map { $0.fullPath }
//            for path in listFullPaths {
//                if path.contains(".PDF") || path.contains(".pdf") {
//                    pdfRef = path
//                    break
//                }
//            }
//            guard let pdfRef = pdfRef else {
//                XCTFail("No PDF file found in \(schematicRef.fullPath)")
//                return
//            }
//            let start = pdfRef.lastIndex(of: "/")!
//            let newStart = pdfRef.index(after: start)
//            let range = newStart..<pdfRef.endIndex
//            let pdfNameString = String(pdfRef[range])
//            print(pdfNameString)
//            schematicRef.child(pdfNameString).getData(maxSize: maxSize) { (data, error) in
//                if let error = error {
//                    XCTFail("\(error)")
//                    return
//                }
//
//                guard let data = data else {
//                    XCTFail("No schematic pdf returned")
//                    return
//                }
//                print("\(data)")
//                getData.fulfill()
//            }
//            listAll.fulfill()
//        }
//        waitForExpectations(timeout: 10) { (error) in
//            if let error = error {
//                XCTFail("\(error)")
//            }
//        }
//    }
    
    func testDownloadAssignedJobSheets() {
        XCTAssertNotNil(projectController.bearer)
        
        let expectation = self.expectation(description: "projectController")
        projectController.downloadAssignedJobs { (error) in
            if let error = error {
                XCTFail("\(error)")
                return
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssertNotNil(projectController.projects)
    }
        
//    func testDownloadSchematics() {
//        XCTAssertNotNil(projectController.bearer)
//        XCTAssertNotNil(projectController.user)
//
//        let expectation = self.expectation(description: "downloadSchematics")
//        projectController.downloadSchematics { (error) in
//            if let error = error {
//                XCTFail("\(error)")
//                return
//            }
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 20, handler: nil)
//        XCTAssertNotNil(projectController.projects)
//    }
}

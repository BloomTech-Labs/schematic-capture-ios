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
    
    func testDownloadSchematicsPDF() {
        let listAll = expectation(description: "List All")
        let getData = expectation(description: "Get Data")
        
        let maxSize: Int64 = 1073741824 // 1GB
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var pdfRef: String?
        let schematicRef = storageRef.child("1")
            .child("1")
            .child("1")
            .child("1")
        schematicRef.listAll { (listResult, error) in
            if let error = error {
                XCTFail("\(error)")
                return
            }
            let listFullPaths = listResult.items.map { $0.fullPath }
            for path in listFullPaths {
                if path.contains(".PDF") || path.contains(".pdf") {
                    pdfRef = path
                    break
                }
            }
            guard let pdfRef = pdfRef else {
                XCTFail("No PDF file found in \(schematicRef.fullPath)")
                return
            }
            let start = pdfRef.lastIndex(of: "/")!
            let newStart = pdfRef.index(after: start)
            let range = newStart..<pdfRef.endIndex
            let pdfNameString = String(pdfRef[range])
            print(pdfNameString)
            schematicRef.child(pdfNameString).getData(maxSize: maxSize) { (data, error) in
                if let error = error {
                    XCTFail("\(error)")
                    return
                }
                
                guard let data = data else {
                    XCTFail("No schematic pdf returned")
                    return
                }
                print("\(data)")
                getData.fulfill()
            }
            listAll.fulfill()
        }
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("\(error)")
            }
        }
    }
}

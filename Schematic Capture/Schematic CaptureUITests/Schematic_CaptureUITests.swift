//
//  Schematic_CaptureUITests.swift
//  Schematic CaptureUITests
//
//  Created by Gi Pyo Kim on 2/3/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import XCTest

class Schematic_CaptureUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAuthenticationNavigation() {
        let app = XCUIApplication()
        app.launch()
        
        
                
        let firstButton = app.buttons["Authorized Technician Portal"]
        firstButton.tap()
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Proceed to main page"]/*[[".otherElements[\"SCLAlertView\"].buttons[\"Proceed to main page\"]",".buttons[\"Proceed to main page\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Download Projects"].tap()
        app.buttons["Done"].tap()
      
     
        app.buttons["View Projects"].tap()
     
        
      
    }
    
    func testDownload() {
        let app = XCUIApplication()
        app.launch()
        
      let firstButton = app.buttons["Authorized Technician Portal"]
      firstButton.tap()
      let loginButton = app.buttons["Login"]
      loginButton.tap()
      
        sleep(5)
        app/*@START_MENU_TOKEN@*/.buttons["Proceed to main page"]/*[[".otherElements[\"SCLAlertView\"].buttons[\"Proceed to main page\"]",".buttons[\"Proceed to main page\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.buttons["Download Projects"].tap()
    }
    
    func testCardView() {
        
        let app = XCUIApplication()
        app.launch()
        
      let firstButton = app.buttons["Authorized Technician Portal"]
      firstButton.tap()
      let loginButton = app.buttons["Login"]
      loginButton.tap()
        sleep(5)
        app/*@START_MENU_TOKEN@*/.buttons["Proceed to main page"]/*[[".otherElements[\"SCLAlertView\"].buttons[\"Proceed to main page\"]",".buttons[\"Proceed to main page\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.buttons["View Projects"].tap()

        let tablesQuery = app.tables
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Test Project 1"]/*[[".cells[\"CellID\"].staticTexts[\"Test Project 1\"]",".staticTexts[\"Test Project 1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.buttons["JobSheetsTableViewController.button.toggleComplete"].tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["HPU_Manifolds Jobsheet 1.csv"]/*[[".cells.staticTexts[\"HPU_Manifolds Jobsheet 1.csv\"]",".staticTexts[\"HPU_Manifolds Jobsheet 1.csv\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        
        let descriptionElectricMotorCellsQuery = tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Description: Electric Motor")/*[[".cells.containing(.staticText, identifier:\"1\")",".cells.containing(.staticText, identifier:\"Part #: 284TC\")",".cells.containing(.staticText, identifier:\"Manufacturer: Baldor\")",".cells.containing(.staticText, identifier:\"Description: Electric Motor\")"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let componentStaticText = descriptionElectricMotorCellsQuery.staticTexts["Component #:"]
        componentStaticText.tap()
        componentStaticText.tap()
        
        descriptionElectricMotorCellsQuery.buttons["ExpyTableViewController.EditComponentButton"].tap()
        
        app.buttons["EditComponentController.DismissButton"].tap()
        
      
      
        
        
        
        let componentStaticText2 = tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Description: Pump, Axial Piston")/*[[".cells.containing(.staticText, identifier:\"2\")",".cells.containing(.staticText, identifier:\"Part #: PVM074ER09GS02AA-28\")",".cells.containing(.staticText, identifier:\"Manufacturer: Vickers\")",".cells.containing(.staticText, identifier:\"Description: Pump, Axial Piston\")"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.staticTexts["Component #:"]
        componentStaticText2.tap()
        componentStaticText2.tap()
        
        
        
        let cameraButton = descriptionElectricMotorCellsQuery.buttons["camera"]
        cameraButton.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Cancel"]/*[[".otherElements[\"SCLAlertView\"].buttons[\"Cancel\"]",".buttons[\"Cancel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        cameraButton.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Photo Library"]/*[[".otherElements[\"SCLAlertView\"].buttons[\"Photo Library\"]",".buttons[\"Photo Library\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tables.cells.firstMatch.tap()
                                        
        

        
    }

//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}

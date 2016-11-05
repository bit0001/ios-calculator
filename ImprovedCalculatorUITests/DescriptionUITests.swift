//
//  DescriptionUITests.swift
//  ImprovedCalculator
//
//  Created by user on 11/5/16.
//  Copyright © 2016 mathsistor. All rights reserved.
//

import XCTest

class DescriptionUITests: XCTestCase {
    
    private var expectedResultDisplay: String!
    private var expectedOperationDisplay: String!
    private var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        XCTAssertEqual(expectedResultDisplay, XCUIApplication().staticTexts["result_display"].label)
        XCTAssertEqual(expectedOperationDisplay, XCUIApplication().staticTexts["operation_display"].label)
        
    }
    
    func test7Plus() {
        expectedResultDisplay = "7"
        expectedOperationDisplay = "7+..."
        
        app.buttons["7"].tap()
        app.buttons["+"].tap()
    }
    
}

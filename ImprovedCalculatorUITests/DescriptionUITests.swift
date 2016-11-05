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
    
    func test7Plus9() {
        expectedResultDisplay = "9"
        expectedOperationDisplay = "7+..."
        
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
    }
    
    func test7Plus9Equal() {
        expectedResultDisplay = "16"
        expectedOperationDisplay = "7+9="
        
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
    }
    
    func test7Plus9EqualSquareRoot() {
        expectedResultDisplay = "4"
        expectedOperationDisplay = "√(7+9)="
        
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["√"].tap()
    }
    
}

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
    
    func test7Plus9SquareRoot() {
        expectedResultDisplay = "3"
        expectedOperationDisplay = "7+√(9)..."
        
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["√"].tap()
    }
    
    func test7Plus9SquareRootEqual() {
        expectedResultDisplay = "10"
        expectedOperationDisplay = "7+√(9)="
        
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["√"].tap()
        app.buttons["="].tap()
    }
    
    func test7Plus9EqualPlus6Plus3Equal() {
        expectedResultDisplay = "25"
        expectedOperationDisplay = "7+9+6+3="
        
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
    }
    
    func test7Plus9EqualSquareRoot6Plus3Equal() {
        expectedResultDisplay = "9"
        expectedOperationDisplay = "6+3="
        
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["√"].tap()
        app.buttons["6"].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
    }
    
    func test5Plus6Equal73() {
        expectedResultDisplay = "73"
        expectedOperationDisplay = "5+6="
        
        app.buttons["5"].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        app.buttons["7"].tap()
        app.buttons["3"].tap()
    }
    
    func test7PlusEqual() {
        expectedResultDisplay = "14"
        expectedOperationDisplay = "7+7="
        
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["="].tap()
    }
    
    func test4TimesPiEqual() {
        expectedResultDisplay = "12.566371"
        expectedOperationDisplay = "4×π="
        
        app.buttons["4"].tap()
        app.buttons["×"].tap()
        app.buttons["π"].tap()
        app.buttons["="].tap()
    }
    
    func test4Plus5Times3Equal() {
        expectedResultDisplay = "27"
        expectedOperationDisplay = "4+5×3="
        
        app.buttons["4"].tap()
        app.buttons["+"].tap()
        app.buttons["5"].tap()
        app.buttons["×"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
    }
    
}

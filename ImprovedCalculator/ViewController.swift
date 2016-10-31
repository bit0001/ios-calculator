//
//  ViewController.swift
//  ImprovedCalculator
//
//  Created by user on 9/23/16.
//  Copyright © 2016 mathsistor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var isUserInMiddleOfTyping = false
    private var brain = CalculatorBrain()
    @IBOutlet private weak var result_display: UILabel!
    @IBOutlet weak var expressionDescription: UILabel!

    @IBOutlet private weak var sin: UIButton!
    @IBOutlet private weak var cos: UIButton!
    @IBOutlet private weak var tan: UIButton!
    @IBOutlet weak var square: UIButton!
    @IBOutlet weak var cube: UIButton!
    

    private var displayedValue: Double {
        get {
            return Double(result_display.text!)!
        }

        set {
            result_display.text = CalculationFormater().formatNumber(number: newValue)
            expressionDescription.text = brain.description + ( brain.isPartialResult ? "..." : "=")
        }
    }

    @IBAction private func touchButton(_ sender: UIButton) {
        let character = sender.currentTitle!
        
        if isUserInMiddleOfTyping {
            guard character != "." || !isPointInDisplayedData() else {
                return
            }
            
            let currentDisplayedData = result_display.text!
            result_display.text = currentDisplayedData + character
        } else {
            result_display.text = character == "." ? "0" + character : character
        }
        
        isUserInMiddleOfTyping = true
    }
    
    private func isPointInDisplayedData() -> Bool {
        return result_display.text!.range(of: ".") != nil
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        let symbol = sender.currentTitle!
        
        if isUserInMiddleOfTyping {
            brain.setOperand(operand: displayedValue)
            isUserInMiddleOfTyping = false
        }

        brain.performOperation(symbol: symbol)
        displayedValue = brain.result
        
    }
    
    @IBAction private func clearEverything(_ sender: AnyObject) {
        result_display.text = "0"
        expressionDescription.text = "0"
        brain = CalculatorBrain()
        isUserInMiddleOfTyping = false
    }
    
    @IBAction func deleteDigit() {
        var currentText = result_display.text!
        let range = currentText.index(currentText.endIndex, offsetBy: -1)..<currentText.endIndex
        currentText.removeSubrange(range)

        if currentText == "" {
            result_display.text = "0"
            isUserInMiddleOfTyping = false
        } else {
            result_display.text = currentText
        }
    }

}

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
    @IBOutlet private weak var resultDisplay: UILabel!
    @IBOutlet private weak var descriptionDisplay: UILabel!
    
    private var displayedValue: Double {
        get {
            return Double(getCurrentDisplayedData())!
        }
        
        set {
            resultDisplay.text = CalculationFormater().formatNumber(number: newValue)
            descriptionDisplay.text = brain.description + ( brain.isPartialResult ? "..." : "=")
        }
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let character = sender.currentTitle!
        
        if isUserInMiddleOfTyping {
            resultDisplay.text = getCurrentDisplayedData() + character
        } else {
            resultDisplay.text = character
        }
        
        isUserInMiddleOfTyping = true
    }
    
    private func getCurrentDisplayedData() -> String {
        return resultDisplay.text!
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
    
    @IBAction private func addDecimalPoint() {
        if (isUserInMiddleOfTyping) {
            if (!getCurrentDisplayedData().contains(".")) {
                resultDisplay.text = getCurrentDisplayedData() +  "."
            }
        } else {
            resultDisplay.text = "0."
        }
        isUserInMiddleOfTyping = true
    }
    
    @IBAction private func clearEverything() {
        resultDisplay.text = "0"
        descriptionDisplay.text = " "
        brain = CalculatorBrain()
        isUserInMiddleOfTyping = false
    }
    
    @IBAction private func deleteDigit() {
        var currentText = getCurrentDisplayedData()
        let range = currentText.index(currentText.endIndex, offsetBy: -1)..<currentText.endIndex
        currentText.removeSubrange(range)
        
        if currentText == "" {
            resultDisplay.text = "0"
            isUserInMiddleOfTyping = false
        } else {
            resultDisplay.text = currentText
        }
    }
    
}

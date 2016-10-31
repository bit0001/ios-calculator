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
    @IBOutlet weak var descriptionDisplay: UILabel!
    

    private var displayedValue: Double {
        get {
            return Double(resultDisplay.text!)!
        }

        set {
            resultDisplay.text = CalculationFormater().formatNumber(number: newValue)
            descriptionDisplay.text = brain.description + ( brain.isPartialResult ? "..." : "=")
        }
    }

    @IBAction private func touchDigit(_ sender: UIButton) {
        let character = sender.currentTitle!
        
        if isUserInMiddleOfTyping {
            guard character != "." || !isPointInDisplayedData() else {
                return
            }
            
            let currentDisplayedData = resultDisplay.text!
            resultDisplay.text = currentDisplayedData + character
        } else {
            resultDisplay.text = character == "." ? "0" + character : character
        }
        
        isUserInMiddleOfTyping = true
    }
    
    private func isPointInDisplayedData() -> Bool {
        return resultDisplay.text!.range(of: ".") != nil
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
    
    @IBAction private func clearEverything() {
        resultDisplay.text = "0"
        descriptionDisplay.text = " "
        brain = CalculatorBrain()
        isUserInMiddleOfTyping = false
    }
    
    @IBAction func deleteDigit() {
        var currentText = resultDisplay.text!
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

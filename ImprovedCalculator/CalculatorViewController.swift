//
//  ViewController.swift
//  ImprovedCalculator
//
//  Created by user on 9/23/16.
//  Copyright © 2016 mathsistor. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet private weak var resultDisplay: UILabel!
    @IBOutlet private weak var descriptionDisplay: UILabel!
    @IBOutlet private weak var deleteUndoButton: UIButton!
    
    private var isUserInMiddleOfTyping = false
    private var brain = CalculatorBrain()
    private var savedProgram: CalculatorBrain.PropertyList?
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
        
        if getCurrentDisplayedData() == "0" && character == "0" {
            return
        }
        
        resultDisplay.text = isUserInMiddleOfTyping ? getCurrentDisplayedData() + character : character
        isUserInMiddleOfTyping = true
        updateDeleteUndoButton()
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        let symbol = sender.currentTitle!
        
        if isUserInMiddleOfTyping {
            brain.setOperand(operand: displayedValue)
            isUserInMiddleOfTyping = false
            updateDeleteUndoButton()
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
        updateDeleteUndoButton()
    }
    
    @IBAction private func clearEverything() {
        resultDisplay.text = "0"
        descriptionDisplay.text = " "
        brain = CalculatorBrain()
        isUserInMiddleOfTyping = false
        updateDeleteUndoButton()
    }
    
    @IBAction private func deleteOrUndo(_ sender: UIButton) {
        if isUserInMiddleOfTyping {
            var currentText = getCurrentDisplayedData()
            let range = currentText.index(currentText.endIndex, offsetBy: -1)..<currentText.endIndex
            currentText.removeSubrange(range)
            
            if currentText == "" {
                resultDisplay.text = "0"
                isUserInMiddleOfTyping = false
                updateDeleteUndoButton()
            } else {
                resultDisplay.text = currentText
            }
        } else {
            brain.undoLastOperation()
            brain.program = brain.program
            displayedValue = brain.result
            isUserInMiddleOfTyping = false
            updateDeleteUndoButton()
        }
    }
    
    
    @IBAction private func save() {
        savedProgram = brain.program
    }
    
    @IBAction private func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayedValue = brain.result
        }
    }
    
    @IBAction private func setVariable(_ sender: UIButton) {
        let variableName = sender.currentTitle!
        let range = variableName.index(variableName.startIndex, offsetBy: 1)..<variableName.endIndex
        brain.variableValues[variableName[range]] = displayedValue
        brain.program = brain.program
        displayedValue = brain.result
        isUserInMiddleOfTyping = false
        updateDeleteUndoButton()
    }
    
    @IBAction private func getVariable(_ sender: UIButton) {
        let variableName = sender.currentTitle!
        brain.setOperand(variableName: variableName)
        displayedValue = brain.result
    }
    
    private func getCurrentDisplayedData() -> String {
        return resultDisplay.text!
    }
    
    private func updateDeleteUndoButton() {
        UIView.setAnimationsEnabled(false)
        deleteUndoButton.setTitle(isUserInMiddleOfTyping ? "←" : "undo", for: .normal)
        deleteUndoButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: CGFloat(isUserInMiddleOfTyping ? 30 : 18))
        UIView.setAnimationsEnabled(true)
    }
    
}

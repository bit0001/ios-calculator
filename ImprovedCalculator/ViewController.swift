//
//  ViewController.swift
//  ImprovedCalculator
//
//  Created by user on 9/23/16.
//  Copyright © 2016 mathsistor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var isShiftPressed = false
    private var isUserInMiddleOfTyping = false
    private var brain = CalculatorBrain()
    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var expressionDescription: UILabel!

    @IBOutlet private weak var sin: UIButton!
    @IBOutlet private weak var cos: UIButton!
    @IBOutlet private weak var tan: UIButton!
    @IBOutlet weak var square: UIButton!
    @IBOutlet weak var cube: UIButton!
    

    private var displayedValue: Double {
        get {
            return Double(display.text!)!
        }

        set {
            display.text = CalculationFormater().formatNumber(number: newValue)
            expressionDescription.text = brain.description + ( brain.isPartialResult ? "..." : "=")
        }
    }

    @IBAction private func touchButton(_ sender: UIButton) {
        let character = sender.currentTitle!
        
        if isUserInMiddleOfTyping {
            guard character != "." || !isPointInDisplayedData() else {
                return
            }
            
            let currentDisplayedData = display.text!
            display.text = currentDisplayedData + character
        } else {
            display.text = character == "." ? "0" + character : character
        }
        
        isUserInMiddleOfTyping = true
    }
    
    private func isPointInDisplayedData() -> Bool {
        return display.text!.range(of: ".") != nil
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
        display.text = "0"
        expressionDescription.text = "0"
        brain = CalculatorBrain()
        isUserInMiddleOfTyping = false
    }
    
    @IBAction func shift(_ sender: UIButton) {
        isShiftPressed = !isShiftPressed
        if isShiftPressed {
            sender.backgroundColor = UIColor(red: CGFloat(175.0 / 255.0), green: CGFloat(128.0 / 255.0), blue: CGFloat(229.0 / 255.0), alpha: 1)
            sin.setTitle("sin⁻¹", for: .normal)
            cos.setTitle("cos⁻¹", for: .normal)
            tan.setTitle("tan⁻¹", for: .normal)
            square.setTitle("x²", for: .normal)
            cube.setTitle("x³", for: .normal)
        } else {
            sender.backgroundColor = UIColor(red: CGFloat(127.0 / 255.0), green: CGFloat(127.0 / 255.0), blue: CGFloat(127.0 / 255.0), alpha: 1)
            sin.setTitle("sin", for: .normal)
            cos.setTitle("cos", for: .normal)
            tan.setTitle("tan", for: .normal)
            square.setTitle("√", for: .normal)
            cube.setTitle("∛", for: .normal)
        }
    }

    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }

    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            display.text = CalculationFormater().formatNumber(number: brain.result)
            expressionDescription.text = brain.description + ( brain.isPartialResult ? "..." : "=")
        }
    }
    
    @IBAction func deleteDigit() {
        var currentText = display.text!
        let range = currentText.index(currentText.endIndex, offsetBy: -1)..<currentText.endIndex
        currentText.removeSubrange(range)

        if currentText == "" {
            display.text = "0"
            isUserInMiddleOfTyping = false
        } else {
            display.text = currentText
        }
    }

}

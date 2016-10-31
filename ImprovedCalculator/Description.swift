//
//  Description.swift
//  ImprovedCalculator
//
//  Created by user on 10/31/16.
//  Copyright © 2016 mathsistor. All rights reserved.
//

import Foundation

class Description {
    var description = ""
    private var previousAppend: String?
    private var baseDescription: String?
    
    func update(symbol: String, accumulator: Double, isPartialResult: Bool) {
        let operation = operations[symbol]!
        switch operation {
        case .Unary(_):
            if isPartialResult {
                if let prevAppend = previousAppend {
                    previousAppend = symbol +  betweenParentheses(description: prevAppend)
                    description = baseDescription! + prevAppend
                } else {
                    baseDescription = description
                    previousAppend = symbol + betweenParentheses(description: getNumberString(number: accumulator))
                    description += previousAppend!
                }
            } else {
                description = symbol + betweenParentheses(description: (description == "" ? getNumberString(number: accumulator) : description))
            }
        case .Binary(_):
            if isPartialResult {
                if previousAppend == nil {
                    description += getNumberString(number: accumulator) + symbol
                } else {
                    description += symbol
                    previousAppend = nil
                }
            } else {
                description = (description == "" ? getNumberString(number: accumulator) : description) + symbol
            }
        case .Equal:
            guard isPartialResult else {
                break
            }
            
            guard previousAppend == nil else {
                previousAppend = nil
                break
            }
            
            description += getNumberString(number: accumulator)
        default:
            break
        }
    }
    
    private func getNumberString(number: Double) -> String {
        switch number {
        case M_PI:
            return "π"
        case M_E:
            return "e"
        default:
            return CalculationFormater().formatNumber(number: number)
        }
    }
    
    private func betweenParentheses(description: String) -> String {
        return "(" + description + ")"
    }
}

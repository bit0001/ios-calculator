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
                if let prevAppend = previousAppend  {
                    previousAppend = symbol + "(" + prevAppend + ")";
                    description = baseDescription! + previousAppend!;
                } else {
                    baseDescription = description;
                    previousAppend = symbol + "(" + getNumberString(number: accumulator) + ")";
                    description += previousAppend!;
                }
            } else {
                if description == "" {
                    description = symbol + "(" + getNumberString(number: accumulator) + ")";
                } else {
                    description = symbol + "(" + description + ")";
                }
            }
        case .Binary(_):
            if isPartialResult {
                if previousAppend == nil {
                    description += getNumberString(number: accumulator) + symbol;
                } else {
                    description += symbol;
                    previousAppend = nil;
                }
            } else {
                if description == "" {
                    description = getNumberString(number: accumulator) + symbol;
                } else {
                    description += symbol;
                }
            }
        case .Equal:
            if (!isPartialResult) {
                return;
            }
            
            if (previousAppend == nil) {
                description += getNumberString(number: accumulator);
            }
            previousAppend = nil;
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
}

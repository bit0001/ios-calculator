//
//  Formatter.swift
//  ImprovedCalculator
//
//  Created by user on 10/30/16.
//  Copyright © 2016 mathsistor. All rights reserved.
//

import Foundation

class CalculationFormater {
    func formatNumber(number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        return formatter.string(from: number as NSNumber)!
    }
}

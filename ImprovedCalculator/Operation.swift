//
//  Operation.swift
//  ImprovedCalculator
//
//  Created by user on 10/31/16.
//  Copyright © 2016 mathsistor. All rights reserved.
//

import Foundation

enum Operator {
    case Constant(Double)
    case Unary((Double) -> Double)
    case Binary((Double, Double) -> Double)
    case Equal
    case Random
}

struct PendingBinaryOperation {
    let binaryFunction: (Double, Double) -> Double
    let fistOperand: Double
}

let operations = [
    "π": Operator.Constant(M_PI),
    "e": Operator.Constant(M_E),
    "+/-": Operator.Unary({ -1 * $0 }),
    "√": Operator.Unary(sqrt),
    "∛": Operator.Unary({ pow($0, 1.0 / 3.0) }),
    "x⁻¹": Operator.Unary({ 1 / $0 }),
    "x²": Operator.Unary({ $0 * $0}),
    "x³": Operator.Unary({ pow($0, 3) }),
    "10ˣ": Operator.Unary({ pow(10, $0) }),
    "eˣ": Operator.Unary({ pow(M_E, $0) }),
    "ln": Operator.Unary(log),
    "log": Operator.Unary(log10),
    "sin": Operator.Unary(sin),
    "cos": Operator.Unary(cos),
    "tan": Operator.Unary(tan),
    "sin⁻¹": Operator.Unary(asin),
    "cos⁻¹": Operator.Unary(acos),
    "tan⁻¹": Operator.Unary(atan),
    "×": Operator.Binary(*),
    "÷": Operator.Binary(/),
    "+": Operator.Binary(+),
    "−": Operator.Binary(-),
    "xʸ": Operator.Binary({ pow($0, $1) }),
    "rand": Operator.Random,
    "=": Operator.Equal
]

import Foundation


class CalculatorBrain {
    typealias PropertyList = AnyObject

    private var accumulator = 0.0
    private var operationDescription = Description()
    private var internalProgram = [AnyObject]()
    var variableValues = [String: Double]()
    private var pending: PendingBinaryOperation?
    private var operand: AnyObject = 0.0 as AnyObject

    var description: String {
        return operationDescription.description
    }

    var result: Double {
        return accumulator
    }

    var isPartialResult: Bool {
        return pending != nil
    }

    func setOperand(operand: Double) {
        accumulator = operand
        self.operand = operand as AnyObject
        internalProgram.append(operand as AnyObject)
        
        if !isPartialResult {
            operationDescription = Description()
        }
    }
    
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let string = op as? String {
                        if  operations[string] != nil {
                            performOperation(symbol: string)
                        } else {
                            setOperand(variableName: string)
                        }
                    }
                }
            }
        }
    }
    
    private func clear() {
        accumulator = 0
        pending = nil
        internalProgram.removeAll()
    }
    

    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            internalProgram.append(symbol as AnyObject)
            operationDescription.update(symbol: symbol, operand: operand, isPartialResult: isPartialResult)
            computeResult(operation: operation)
        }
    }

    private func computeResult(operation: Operator) {
        switch operation {
        case .Constant(let constant):
            accumulator = constant
        case .Unary(let function):
            accumulator = function(accumulator)
        case .Binary(let function):
            executePendingBinaryOperation()
            pending = PendingBinaryOperation(binaryFunction: function, fistOperand: accumulator)
        case .Equal:
            executePendingBinaryOperation()
        case .Random:
            accumulator = drand48()
        }
    }

    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.fistOperand, accumulator)
            pending = nil
        }
    }
    
    func setOperand(variableName: String) {
        let operand = variableValues[variableName] ?? 0.0
        accumulator = operand
        internalProgram.append(variableName as AnyObject)
        self.operand = variableName as AnyObject
        
        if !isPartialResult {
            operationDescription = Description()
        }
    }

}

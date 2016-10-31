import Foundation


class CalculatorBrain {

    private var accumulator = 0.0
    private var operationDescription = Description()
    private var pending: PendingBinaryOperation?

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
        
        if !isPartialResult {
            operationDescription = Description()
        }
    }

    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            operationDescription.update(symbol: symbol, accumulator: accumulator, isPartialResult: isPartialResult)
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

    private func getStringBetweenParenthesis(description: String) -> String {
        return "(" + description + ")"
    }

    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.fistOperand, accumulator)
            pending = nil
        }
    }

}

import Foundation

func factorial(number: Double) -> Double {
    if number == 0.0 || number == 1.0 {
        return 1.0
    }
    return factorial(number: number - 1.0)
}

class CalculatorBrain {

    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    private var previousOperationIsConstantOrUnary = false
    private var previousOperatorIsEqual = false

    var result: Double {
        return accumulator
    }

    var description = ""

    var isPartialResult: Bool {
        return pending != nil
    }

    func setOperand(operand: Double) {
        if previousOperationIsConstantOrUnary || previousOperatorIsEqual {
            description = ""
            previousOperationIsConstantOrUnary = false
            previousOperatorIsEqual = false
        }
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    var variableValues: Dictionary<String, Double>!
    
    func setOperand(variableName: String) {
        
    }

    private enum Operator {
        case Constant(Double)
        case Unary((Double) -> Double)
        case Binary((Double, Double) -> Double)
        case Equal
        case Random
    }

    private let operations = [
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

    private struct PendingBinaryOperation {
        let binaryFunction: (Double, Double) -> Double
        let fistOperand: Double
    }

    private var pending: PendingBinaryOperation?

    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            description = updateDescription(symbol: symbol)
            computeResult(operation: operation)
            updatePreviousOperationFlags(operation: operation)
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

    private func updateDescription(symbol: String) -> String {
        let operation = operations[symbol]!
        switch operation {
        case .Constant(_):
            return (isPartialResult ? description + symbol : symbol)
        case .Unary(_):
            return (isPartialResult ?
                description + symbol + getStringBetweenParenthesis(description: String(accumulator)) :
                symbol + getStringBetweenParenthesis(
                    description: description == "" ? String(accumulator) : description))
        case .Binary(_):
            return (previousOperationIsConstantOrUnary || previousOperatorIsEqual ?
                description + symbol : description + getNumberString(number: accumulator) + symbol)
        case .Equal:
            return (isPartialResult && !previousOperationIsConstantOrUnary ?
                description + getNumberString(number: accumulator) : description)
        default:
            return description
        }
    }

    private func getStringBetweenParenthesis(description: String) -> String {
        return "(" + description + ")"
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

    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.fistOperand, accumulator)
            pending = nil
        }
    }

    private func updatePreviousOperationFlags(operation: Operator) {
        switch operation {
        case .Constant(_):
            previousOperationIsConstantOrUnary = true
            previousOperatorIsEqual = false
        case .Unary(_):
            previousOperationIsConstantOrUnary = true
            previousOperatorIsEqual = false
        case .Binary(_):
            previousOperationIsConstantOrUnary = false
            previousOperatorIsEqual = false
        case .Equal:
            previousOperationIsConstantOrUnary = false
            previousOperatorIsEqual = true
        case .Random:
            previousOperationIsConstantOrUnary = false
            previousOperatorIsEqual = false
        }
    }
    
    typealias PropertyList = AnyObject
    
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
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    private func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
}

class CalculationFormater {
    func formatNumber(number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        return formatter.string(from: number as NSNumber)!
    }
}

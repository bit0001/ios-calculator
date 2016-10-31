import Foundation


class CalculatorBrain {

    private var accumulator = 0.0
    private var previousAppend: String?
    private var baseDescription: String?

    var result: Double {
        return accumulator
    }

    var description = ""

    var isPartialResult: Bool {
        return pending != nil
    }

    func setOperand(operand: Double) {
        accumulator = operand
        
        if !isPartialResult {
            description = ""
        }
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
        if let operation = operations[symbol] {
            updateDescription(symbol: symbol)
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

    private func updateDescription(symbol: String) {
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

}

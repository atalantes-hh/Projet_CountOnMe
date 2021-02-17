//
//  Calculator.swift
//  CountOnMe
//
//  Created by Johann on 02/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

// MARK: Protocol
// Update View and Alert
protocol CalculatorDelegate: class {
    func updateDisplay(_ calculInProgress: String)
    func showAlertPopUp(title: String, message: String)
}

final class Calculator {
    
    // MARK: - Enumerations
    // Print error message when Operation impossible
    enum ErrorCase {
        case basic, operationImpossible, operationHaveResult, wrongOperator, divideByZero, decimalExist, keeping
        var title: String {
            switch self {
            case .basic: return "Error"
            case .operationImpossible: return "Error"
            case .operationHaveResult: return "Warning"
            case .wrongOperator: return "Error"
            case .divideByZero: return "Error"
            case .decimalExist: return "Warning"
            case .keeping: return "Error"
            }
        }
        var message: String {
            switch self {
            case .basic: return "Operation impossible"
            case .operationImpossible: return "This operation already have a result. Press K to Use last result"
            case .operationHaveResult: return "This operation already have a result. Press AC to clear last operation"
            case .wrongOperator: return "An operand already exist !"
            case .divideByZero: return "You try to divide by 0. This operation is impossible"
            case .decimalExist: return "A decimal was already added to the operation"
            case .keeping: return "Nothing to keep"
            }
        }
    }
    
    // MARK: - Properties
    
    weak var delegate: CalculatorDelegate?
    
    // Diplay operation on screen
    var calculInProgress: String = "" {
        didSet {
            delegate?.updateDisplay(calculInProgress)
        }
    }
    
    // Rewrite operation and remove space
    private var operation: [String] {
        return calculInProgress.split(separator: " ").map { "\($0)" }
    }
    
    // Check is first element is a number
    private var firstValue: Bool {
        if operation.count < 1 {
            return operation.first != "+" && operation.first != "-" &&
                operation.first != "÷" && operation.first != "x" && operation.first != "."
        }
        return false
    }
    
    // Check if last element is a Operator
    private var canAddOperator: Bool {
        return operation.last != "+" && operation.last != "-" && operation.last != "÷" &&
            operation.last != "x" && operation.last != "."
    }
    
    // Check if we have necessary elements for calcul
    private var expressionHaveEnoughElement: Bool {
        return operation.count >= 3
    }
    
    // Operation have a result
    private var operationHaveResult: Bool {
        return calculInProgress.firstIndex(of: "=") != nil
    }
    
    // To keep last result for an other operation
    func keepResult() {
        guard operationHaveResult,
              let lastResult = operation.last else { return errorMessage(alert: .basic) }
        calculInProgress = lastResult
    }
    
    // Display error message for the actual alert
    func errorMessage(alert: ErrorCase) {
        delegate?.showAlertPopUp(title: alert.title, message: alert.message)
    }
    
    // Prevent divide by 0
    private var divideByZero: Bool {
        return calculInProgress.contains("÷ 0")
    }
    
    // Adding Number to the operation
    func appendSelectedNumber(_ numberText: String) {
        calculInProgress.append(numberText)
    }
    
    // Adding Decimal to the operation
    func isDecimal(_ isDecimal: String) {
        guard operation.last?.contains(".") == false else { return errorMessage(alert: .decimalExist) }
        guard canAddOperator else { return errorMessage(alert: .basic) }
        
        calculInProgress.append(isDecimal)
    }
    
    // Adding Operand to the operation
    func operand(_ operandChoice: String) {
        guard !operationHaveResult else { return errorMessage(alert: .operationImpossible) }
        guard !firstValue else { return errorMessage(alert: .basic) }
        if canAddOperator {
            switch operandChoice {
            case "+":
                calculInProgress.append(" + ")
            case "-":
                calculInProgress.append(" - ")
            case "x":
                calculInProgress.append(" x ")
            case "÷":
                calculInProgress.append(" ÷ ")
            default: break
            }
        } else {
            errorMessage(alert: .wrongOperator)
        }
    }
    
    // Remove Decimal
    private func formatDecimal(number: Double) -> String {
        let format = NumberFormatter()
        format.minimumFractionDigits = 0
        format.maximumFractionDigits = 5
        guard let value = format.string(from: NSNumber(value: number)) else { return ""}
        return value
    }
    
    // Correction
    func correction() {
        guard !operationHaveResult else { return errorMessage(alert: .operationHaveResult)}
        if calculInProgress.last == " " {
            calculInProgress = String(calculInProgress.dropLast(3))
        } else {
            calculInProgress = String(calculInProgress.dropLast())
        }
    }
    
    // Remove all elements
    func reset() {
        calculInProgress.removeAll()
        delegate?.updateDisplay("")
    }
    
    // Method to the operations
    private func calculate(leftNumber: Double, operand: String, rightNumber: Double) -> Double {
        var result: Double = 0.0
        switch operand {
        case "+": result = leftNumber + rightNumber
        case "-": result = leftNumber - rightNumber
        case "x": result = leftNumber * rightNumber
        case "÷": result = leftNumber / rightNumber
        default: break
        }
        return result
    }
    
    // Reduce all the operation
    func makeOperation() {
        guard canAddOperator, expressionHaveEnoughElement, !operationHaveResult else {
            return errorMessage(alert: .basic)
        }
        guard !divideByZero else { return errorMessage(alert: .divideByZero) }
        
        var operationsToReduce = operation
        let priorityOperators = ["x", "÷"]
        let classicOperators = ["+", "-"]
        var currentIndex: Int?
        var result = ""
        
        while operationsToReduce.count > 1 {
            
            let indexPriorityOperator = operationsToReduce.firstIndex(where: {priorityOperators.contains($0)})
            if let operatorActivePrior = indexPriorityOperator {
                currentIndex = operatorActivePrior
            } else {
                let indexClassicOperator = operationsToReduce.firstIndex(where: {classicOperators.contains($0)})
                if let operatorActiveClassic = indexClassicOperator {
                    currentIndex = operatorActiveClassic
                }
            }
            if let index = currentIndex {
                let operand = operationsToReduce[index]
                let onLeft = Double(operationsToReduce[index - 1])
                let onRight = Double(operationsToReduce[index + 1])
                result = formatDecimal(number: calculate(leftNumber: onLeft!, operand: operand, rightNumber: onRight!))
                operationsToReduce[index] = result
                operationsToReduce.remove(at: index + 1)
                operationsToReduce.remove(at: index - 1)
                calculInProgress.removeAll()
            }
            calculInProgress.append(" = \(operationsToReduce.first!)")
        }
    }
}

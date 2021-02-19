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
    // Print error message when operations errors
    enum ErrorCase {
        case operationImpossible, operationHaveResult, wrongOperator, divideByZero, decimalExist, keeping, syntax
        var title: String {
            switch self {
            case .operationImpossible: return "Error"
            case .operationHaveResult: return "Warning"
            case .wrongOperator: return "Error"
            case .divideByZero: return "Error"
            case .decimalExist: return "Warning"
            case .keeping: return "Error"
            case .syntax: return "Correction"
            }
        }
        var message: String {
            switch self {
            case .operationImpossible: return "This operation is impossible"
            case .operationHaveResult: return "This operation have a result. Press K to Keep last result or AC to clear"
            case .wrongOperator: return "An operand already exist !"
            case .divideByZero: return "You try to divide by 0. This operation is impossible"
            case .decimalExist: return "A decimal was already added to the operation"
            case .keeping: return "Nothing to keep"
            case .syntax: return "Syntax error, you need to correct the operation"
            }
        }
    }
    
    // MARK: - Properties
    
    weak var delegate: CalculatorDelegate?
    
    // Display operation on screen
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
                operation.first != "÷" && operation.first != "x"
        }
        return false
    }
    
    // Check if last element in operation is an operator
    private var canAddOperator: Bool {
        return operation.last != "+" && operation.last != "-" && operation.last != "÷" &&
            operation.last != "x"
    }
    
    // Check if we have 3 necessary elements for calcul
    private var expressionHaveEnoughElement: Bool {
        guard operationHaveResult == false else { return true }
        return operation.count >= 3
    }
    
    // Operation have a result
    private var operationHaveResult: Bool {
        return calculInProgress.firstIndex(of: "=") != nil
    }
    
    // Prevent divide by 0
    private var divideByZero: Bool {
        return calculInProgress.contains("÷ 0")
    }
    
    // MARK: - Functions
    
    // Display error message for the actual alert
    func errorMessage(alert: ErrorCase) {
        delegate?.showAlertPopUp(title: alert.title, message: alert.message)
    }
    
    // Adding number to the operation
    func appendSelectedNumber(_ numberText: String) {
        guard !operationHaveResult else { return errorMessage(alert: .operationHaveResult) }
        calculInProgress.append(numberText)
    }
    
    // Adding decimal to the operation
    func isDecimal() {
        guard operation.first?.contains("") == false else { return errorMessage(alert: .syntax) }
        guard operation.last?.contains(".") == false else { return errorMessage(alert: .decimalExist) }
        guard canAddOperator else { return errorMessage(alert: .syntax) }
        
        calculInProgress.append(".")
    }
    
    // Adding operand to the operation
    func appendOperand(_ operandChoice: String) {
        guard !operationHaveResult else { return errorMessage(alert: .operationHaveResult) }
        guard !firstValue else { return errorMessage(alert: .operationImpossible) }
        guard operation.last?.last != "." else { return errorMessage(alert: .syntax) }
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
            default: errorMessage(alert: .operationImpossible)
            }
        } else {
            errorMessage(alert: .wrongOperator)
        }
    }
    
    // Correction elements
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
    
    // To keep last result for an other operation
    func keepResult() {
        guard operationHaveResult, let lastResult = operation.last else { return errorMessage(alert: .keeping) }
        calculInProgress = lastResult
    }
    
    // Reduce all the operation and make full calculation
    func makeOperation() {
        guard expressionHaveEnoughElement else { return errorMessage(alert: .operationImpossible) }
        guard canAddOperator, !operationHaveResult else { return errorMessage(alert: .operationHaveResult) }
        guard !divideByZero else { return errorMessage(alert: .divideByZero) }
        guard operation.last?.last != "." else { return errorMessage(alert: .syntax) }
        
        var operationsToReduce = operation
        let priorityOperators = ["x", "÷"]
        let classicOperators = ["+", "-"]
        var currentIndex: Int?
        var result = ""
        
        while operationsToReduce.count > 1 {
            
            // Checking priority operators
            let indexPriorityOperator = operationsToReduce.firstIndex(where: {priorityOperators.contains($0)})
            if let operatorActivePrior = indexPriorityOperator {
                currentIndex = operatorActivePrior
            } else {
                // Classic operators
                let indexClassicOperator = operationsToReduce.firstIndex(where: {classicOperators.contains($0)})
                if let operatorActiveClassic = indexClassicOperator {
                    currentIndex = operatorActiveClassic
                }
            }
            
            // Execute method to make calculation by verify index
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
            calculInProgress.append(" = \(operationsToReduce.last!)")
        }
    }
    
    // Method to calculate when operand
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
    
    // Format method to remove decimal
    private func formatDecimal(number: Double) -> String {
        let format = NumberFormatter()
        format.minimumFractionDigits = 0
        format.maximumFractionDigits = 5
        guard let value = format.string(from: NSNumber(value: number)) else { return ""}
        return value
    }
}

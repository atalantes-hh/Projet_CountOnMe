//
//  Calculator.swift
//  CountOnMe
//
//  Created by Johann on 02/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculatorDelegate: class {
    func updateDisplay(_ calculInProgress: String)
    func showAlertPopUp(title: String, message: String)
}

class Calculator {
    weak var delegate: CalculatorDelegate?
    
    // Operation on screen
    var calculInProgress: String = "" {
        didSet {
            delegate?.updateDisplay(calculInProgress)
        }
    }
    
    // Rewrite operation and remove space
    private var operationElements: [String] {
        return calculInProgress.split(separator: " ").map { "\($0)" }
    }
    
    private var lastResult: String = ""
    
    // Check if last element is a Operator
    var canAddOperator: Bool {
        return operationElements.last != "+" && operationElements.last != "-" &&
            operationElements.last != "x" && operationElements.last != "/"
    }
    
    // Check if we have necessary for calcul
    var expressionHaveEnoughElement: Bool {
        return operationElements.count >= 3
    }
    
    private var operationHaveResult: Bool {
        return calculInProgress.firstIndex(of: "=") != nil
       }
    
    enum ErrorCase {
        case wrongOperator, operationImpossible, operationHaveResult, basic, divideByZero
    }
    
    // Print error message when Operation impossible
    func errorMessage(alert: ErrorCase) {
        switch alert {
        case .basic:
            delegate?.showAlertPopUp(title: "Error", message: "Operation impossible")
        case .wrongOperator:
            delegate?.showAlertPopUp(title: "Error", message: "An operand already exist !")
        case .operationImpossible:
            delegate?.showAlertPopUp(title: "Error", message: """
                This operation already have a result.
                Press K to Use last result
                """)
            lastResult = calculInProgress
        case .divideByZero:
            delegate?.showAlertPopUp(title: "Error", message: "Divide by 0. This operation is impossible")
        case .operationHaveResult:
            delegate?.showAlertPopUp(title: "Warning", message: """
                This operation already have a result.
                Press AC to clear last operation
                """)
        }
    }
    
    // divide by 0
    private var divideByZero: Bool {
        return calculInProgress.contains("/ 0")
    }
    
    let priorityOperators = ["x", "/"]
    
    // Adding Number
    func appendSelectedNumber(_ numberText: String) {
        calculInProgress.append(numberText)
    }
    
    // Adding Operand to the expression
    func operand(_ operandChoice: String) {
        if canAddOperator {
            switch operandChoice {
            case "+":
                calculInProgress.append(" + ")
            case "-":
                calculInProgress.append(" - ")
            case "x":
                calculInProgress.append(" x ")
            case "/":
                calculInProgress.append(" / ")
            default: break
            }
        } else {
            errorMessage(alert: .wrongOperator)
        }
    }
    
    func makeOperation() {
        guard canAddOperator, expressionHaveEnoughElement, !operationHaveResult else {
            return errorMessage(alert: .basic) }
        var operationsToReduce = operationElements
        
        while operationsToReduce.count > 1 {
            let leftNumber = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let rightNumber = Double(operationsToReduce[2])!
            
            let result: Double
            
   //         let IndexPriorityOperator = operationsToReduce.firstIndex(where: {priorityOperators.contains($0)})
     
            result = calculate(leftNumber: (leftNumber), operand: (operand), rightNumber: (rightNumber))
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
            
        }
        calculInProgress.append(" = \(operationsToReduce.first!)")
    }
    
    private func calculate(leftNumber: Double, operand: String, rightNumber: Double) -> Double {
        let result: Double
        switch operand {
        case "+": result = leftNumber + rightNumber
        case "-": result = leftNumber - rightNumber
        case "x": result = leftNumber * rightNumber
        case "/": result = leftNumber / rightNumber
        default: fatalError("Unknown operator !")
        }
        return result
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
    
    func clearCalculation() {
        calculInProgress.removeAll()
        delegate?.updateDisplay("0")
    }
    
    func decimal(_ floatNumber: String) {
        calculInProgress.append(floatNumber)
    }
}

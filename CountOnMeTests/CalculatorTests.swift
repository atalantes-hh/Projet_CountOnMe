//
//  CalculatorTests.swift
//  CountOnMeTests
//
//  Created by Johann on 03/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class CalculatorTests: XCTestCase {
    
    var calculator: Calculator!
    var calculatorDelegateMock = CalculatorDelegateMock()
    
    override func setUp() {
        super.setUp()
        calculator = Calculator()
        calculator.delegate = calculatorDelegateMock
    }
    
    // MARK: - Test Calcul
    // Addition
    func testGiven2Plus3_WhenAddition_ThenResultShouldBe5() {
        calculator.appendSelectedNumber("2")
        calculator.appendOperand("+")
        calculator.appendSelectedNumber("3")
        calculator.makeOperation()
        XCTAssertEqual(calculator.calculInProgress, " = 5")
    }
    
    // Substraction
    func testGiven5Minus2_WhenSubstraction_ThenResultShouldBe3() {
        calculator.appendSelectedNumber("5")
        calculator.appendOperand("-")
        calculator.appendSelectedNumber("2")
        calculator.makeOperation()
        XCTAssertEqual(calculator.calculInProgress, " = 3")
    }
    
    // Multiplication
    func testGiven6Multiplying3_WhenMultiplication_ThenResultSouldBe18() {
        calculator.appendSelectedNumber("6")
        calculator.appendOperand("x")
        calculator.appendSelectedNumber("3")
        calculator.makeOperation()
        XCTAssertEqual(calculator.calculInProgress, " = 18")
    }
    
    // Division
    func testGiven1ODivide2_WhenDivision_ThenResultSouldBe5() {
        calculator.appendSelectedNumber("10")
        calculator.appendOperand("÷")
        calculator.appendSelectedNumber("2")
        calculator.makeOperation()
        XCTAssertEqual(calculator.calculInProgress, " = 5")
    }
    
    // Test Complexe Operation
    func testComplexeOperation_WhenAllOperand_ThenResultSouldBe67Dot9() {
        calculator.calculInProgress = "40 + 6 x 9.3 ÷ 2"
        calculator.makeOperation()
        XCTAssertEqual(calculator.calculInProgress, " = 67.9")
    }
    
    // Keep Result
    func testGivenKeepResult_WhenKeepPress_ThenCalculInProgressShoudBe1() {
        calculator.calculInProgress = "3 - 2"
        calculator.makeOperation()
        calculator.keepResult()
        XCTAssertEqual(calculator.calculInProgress, "1")
    }
    
    // Test Number Correction
    func testGiven5Plus23_WhenCorrectionForLastNumber_ThenResultSouldBe5Plus2() {
        calculator.calculInProgress = "5 + 23"
        calculator.correction()
        XCTAssertTrue(calculator.calculInProgress == "5 + 2")
    }
    
    // Test Operand Correction
    func testGiven5Plus23Minus_WhenCorrectionForLastOperand_ThenResultSouldBe5Plus23() {
        calculator.calculInProgress = "5 + 23 - "
        calculator.correction()
        XCTAssertTrue(calculator.calculInProgress == "5 + 23")
    }
    
    // Test Reset Method
    func testResetOperation_WhenPressReset_ThenResultSouldBeNothing() {
        calculator.calculInProgress = "5 / 2"
        calculator.reset()
        XCTAssertEqual(calculator.calculInProgress, "")
    }
    
    // Test Format Result
    func testFormatResult_WhenDecimalReduction_ThenResultSouldBeFalseCase1AndTrueCase2() {
        calculator.calculInProgress = "11 ÷ 3.5"
        calculator.makeOperation()
        XCTAssertFalse(calculator.calculInProgress == " = 3.14285714")
        XCTAssertTrue(calculator.calculInProgress == " = 3.14286")
    }
    
    // MARK: - Test Alert
    
    // Alert enough Elements Test
    func testOperationIsImpossible_WhenOperationHaventEnoughElements_ThenResultSouldBeFalse() {
        calculator.appendSelectedNumber("2 + ")
        calculator.makeOperation()
        XCTAssertEqual(calculator.calculInProgress, "2 + ")
        XCTAssertEqual(calculatorDelegateMock.testAlertTitle, Calculator.ErrorCase.operationImpossible.title)
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.operationImpossible.message)
    }
    
    // Alert Division by 0
    func testGivenAlertMessage_WhenLastElementsAreDivideandZero_ThenResultSouldBeDisplayAlertMessage() {
        calculator.calculInProgress = "5 ÷ 0"
        calculator.makeOperation()
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.divideByZero.message)
    }
    
    // Alert can't add 2 Operators
    func testGivenAlertMessage_WhenAlreadyHaveAnOperand_ThenResultSouldBeAlertMessage() {
        calculator.calculInProgress = "5 + "
        calculator.appendOperand("+")
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.wrongOperator.message)
    }
    
    // Alert Double Decimal
    func testGivenDecimalExist_WhenAlreadyHaveAPoint_ThenResultSouldBeAlertMessage() {
        calculator.calculInProgress = "5 + 3"
        calculator.isDecimal()
        calculator.isDecimal()
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.decimalExist.message)
    }
    
    // Alert Double Equal
    func testGivenResult_WhenDoubleEqual_ThenResultShouldBeAlert() {
        calculator.appendSelectedNumber("2")
        calculator.appendOperand("+")
        calculator.appendSelectedNumber("3")
        calculator.makeOperation()
        XCTAssertEqual(calculator.calculInProgress, " = 5")
        calculator.makeOperation()
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.operationHaveResult.message)
    }
    
    // Alert Correction After Result
    func testGivenAlertMessage_WhenCorrectionAfterEqual_ThenResultShouldBeAlert() {
        calculator.calculInProgress = "5 + 23"
        calculator.makeOperation()
        calculator.correction()
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.operationHaveResult.message)
    }
    
    // Alert Error Syntax
    func testGivenAlertMessage_WhenAppendPlusAfterDecimal_ThenResultShouldBeAlert() {
        calculator.calculInProgress = "3."
        calculator.appendOperand("+")
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.syntax.message)
    }
    
    // Alert Adding Operand Last
    func testGivenAlertMessage_WhenOperandAfterResult_ThenResultShouldBeAlert() {
        calculator.calculInProgress = "5 + 3"
        calculator.makeOperation()
        calculator.appendOperand("-")
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.operationHaveResult.message)
    }
    
    // Alert Adding Operand First
    func testGivenAlertMessage_WhenStartWithOperand_ThenResultSouldBeAlert() {
        calculator.appendOperand("+")
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.operationImpossible.message)
    }
    
    // Alert Adding Decimal First
    func testGivenAlertMessage_WhenStartWithDecimal_ThenResultSouldBeAlert() {
        calculator.calculInProgress = ""
        calculator.isDecimal()
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.syntax.message)
    }
    
    // Alert Adding Decimal After Operand
    func testGivenAlertMessage_WhenDecimalAfterOperator_ThenResultSouldBeAlert() {
        calculator.calculInProgress = "5 + "
        calculator.isDecimal()
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.syntax.message)
    }
    
    // Alert Adding Decimal After Result
    func testGivenAlertMessage_WhenDecimalBeforeEqual_ThenResultSouldBeAlert() {
        calculator.calculInProgress = "5 + 3."
        calculator.makeOperation()
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.syntax.message)
    }
    
    // Alert Adding Number After Result
    func testGivenAlertMessage_WhenNumberAfterResult_ThenResultShouldBeAlert() {
        calculator.calculInProgress = "5 + 6"
        calculator.makeOperation()
        calculator.appendSelectedNumber("3")
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.operationHaveResult.message)
    }
    
    // Alert Keep Result
    func testKeepOnce_WhenPressKeep_ThenResultSouldBeAlertMessage() {
        calculator.calculInProgress = "5 + 2 - 3"
        calculator.makeOperation()
        calculator.keepResult()
        calculator.calculInProgress = "4"
        calculator.keepResult()
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.keeping.message)
    }
    
    // Alert Unknow Operand
    func testGivenAlertMessage_WhenUnknowOperand_ThenResultSouldBeAlertMessage() {
        calculator.calculInProgress = "5"
        calculator.appendOperand("E")
        XCTAssertEqual(calculatorDelegateMock.testAlertMessage, Calculator.ErrorCase.operationImpossible.message)
    }
}

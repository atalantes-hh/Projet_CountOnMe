//
//  CalculatorTests.swift
//  CountOnMeTests
//
//  Created by Johann on 03/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculatorTests: XCTestCase {
    
    var calculator: Calculator!
    
    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }
    
    func testOperationIsPossible_WhenLastElementIsntAnOperator_ThenResultSouldBeTrue() {
        
    }
    func testGiven2Plus3_WhenAddition_ThenResultShouldBe5() {
        calculator.appendSelectedNumber("2")
        calculator.operand("+")
        calculator.appendSelectedNumber("3")
        calculator.makeOperation()
        XCTAssertEqual(calculator.calculInProgress, "2 + 3 = 5.0")
    }
    func testGiven5Minus2_WhenSubstraction_ThenResultShouldBe3() {
        calculator.appendSelectedNumber("5")
        calculator.operand("-")
        calculator.appendSelectedNumber("2")
        calculator.makeOperation()
        XCTAssertEqual(calculator.calculInProgress, "5 - 2 = 3.0")

    }
    func testGiven6Multiplying3_WhenMultiplication_ThenResultSouldBe18() {
        calculator.appendSelectedNumber("6")
        calculator.operand("x")
        calculator.appendSelectedNumber("3")
        calculator.makeOperation()
        XCTAssertEqual(calculator.calculInProgress, "6 x 3 = 18.0")

    }
    func testGiven1ODivide2_WhenDivision_ThenResultSouldBe5() {
        calculator.appendSelectedNumber("10")
        calculator.operand("/")
        calculator.appendSelectedNumber("2")
        calculator.makeOperation()
        XCTAssertEqual(calculator.calculInProgress, "10 / 2 = 5.0")

    }
    
}

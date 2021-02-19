//
//  CalculatorDelegateMock.swift
//  CountOnMeTests
//
//  Created by Johann on 18/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculatorDelegateMock: CalculatorDelegate {
    var testAlertTitle: String = ""
    var testAlertMessage: String = ""
    
    func updateDisplay(_ calculInProgress: String) {
    }
    
    func showAlertPopUp(title: String, message: String) {
        testAlertTitle = title
        testAlertMessage = message
    }
}

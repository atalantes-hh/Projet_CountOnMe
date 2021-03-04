//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - @IBOUtlet
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet var calculaterButtons: [UIButton]!
    
    // MARK: - Private Property
    
    private let calculator = Calculator()
    
    // MARK: - View Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
        
        textView.layer.cornerRadius = 6
        textView.text = calculator.calculInProgress
    }
    
    // MARK: - @IBAction
    
    @IBAction private func tappedAllClearButton(_ sender: UIButton) {
        calculator.reset()
    }
    
    @IBAction private func tappedCorrectionButton(_ sender: UIButton) {
        calculator.correction()
    }
    
    @IBAction private func tappedKeepButton(_ sender: UIButton) {
        calculator.keepResult()
    }
    
    @IBAction private func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else { return }
        calculator.appendSelectedNumber(numberText)
    }
    
    @IBAction private func tappedDecimalButton(_ sender: UIButton) {
        calculator.isDecimal()
    }
    
    @IBAction private func tappedOperatorsButton(_ sender: UIButton) {
        guard let operandChoice = sender.title(for: .normal) else { return }
        calculator.appendOperand(operandChoice)
    }
    
    @IBAction private func tappedEqualButton(_ sender: UIButton) {
        calculator.makeOperation()
    }
}

// MARK: - Extensions

extension ViewController: CalculatorDelegate {
    func updateDisplay(_ calculInProgress: String) {
        textView.text = calculInProgress
        textView.layer.cornerRadius = 6
    }
    
    func showAlertPopUp(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

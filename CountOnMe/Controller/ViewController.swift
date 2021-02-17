//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - @IBOUtlet
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var calculaterButtons: [UIButton]!
    
    // MARK: - Private Property
    
    private var calculator = Calculator()
    
    // MARK: - @IBAction
    
    // Reset calculator
    @IBAction func tappedAllClear(_ sender: UIButton) {
        calculator.reset()
    }
    
    @IBAction func tappedKeep(_ sender: UIButton) {
        calculator.keepResult()
    }
    // Remove Last element
    @IBAction func correction(_ sender: UIButton) {
        calculator.correction()
    }
    
    // Append operator to expression
    @IBAction func tappedOperators(_ sender: UIButton) {
        guard let operandChoice = sender.title(for: .normal) else { return }
        calculator.operand(operandChoice)
    }
    
    @IBAction func tappedDecimalMode(_ sender: UIButton) {
        guard let floatNumber = sender.title(for: .normal) else { return }
        calculator.isDecimal(floatNumber)
    }
    
    // Append new number
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else { return }
        calculator.appendSelectedNumber(numberText)
    }
    
    // When result ask
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.makeOperation()
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.cornerRadius = 6
        calculator.delegate = self
        // Do any additional setup after loading the view.
    }
}

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

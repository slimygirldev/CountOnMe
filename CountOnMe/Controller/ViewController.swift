//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var calculatorView: CalculatorView!

    let alertService: AlertProvider = AlertProvider()

    var elements: [String] {
        // Separation of text into array for exemple :
        // 1 + 1 = 2
        // ["1", "+", "1", "=", "2"]
        return calculatorView.textView.text.split(separator: " ").map { "\($0)" }
    }

    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }

    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }

    var expressionHaveResult: Bool {
        return calculatorView.textView.text.firstIndex(of: "=") != nil
    }

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculatorView.delegate = self
    }

    // View actions
    func tappedNumberButton(numberBtn: String?) {
        if let unwrappedNumberBtn = numberBtn {
            if expressionHaveResult || calculatorView.textView.text == "0" {
                calculatorView.textView.text = ""
            }
            calculatorView.textView.text.append(unwrappedNumberBtn)
        }
    }

    func handleOperation(sign: String) {
        if canAddOperator {
            calculatorView.textView.text.append(" \(sign) ")
        } else {
            return self.present(alertService.alertError(alertType: .duplicateOperator),
                                animated: true, completion: nil)
        }
    }

    func tappedEqualButton() {
        guard expressionIsCorrect else {
            return self.present(alertService.alertError(alertType: .notEnoughElement),
                                animated: true, completion: nil)
        }
        guard expressionHaveEnoughElement else {
            return self.present(alertService.alertError(alertType: .uncorrectExpression),
                                animated: true, completion: nil)
        }
        // Create local copy of operations
        var operationsToReduce = elements
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "÷":
                if right == 0 {
                    return
                } else {
                    result = left / right
                }
            case "x": result = left * right
            default:
                calculatorView.textView.text = ""
                return self.present(alertService.alertError(alertType: .uncorrectExpression),
                                  animated: true, completion: nil)
            }
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        calculatorView.textView.text.append(" = \(operationsToReduce.first!)")
    }
}

extension ViewController: CalculatorViewDelegate {
    func calculatorViewDelegateTappedDivideButton() {
        handleOperation(sign: "÷")
    }

    func calculatorViewDelegateTappedMultiplyButton() {
        handleOperation(sign: "x")
    }

    func calculatorViewDelegateTappedNumberButton(numberText: String?) {
        tappedNumberButton(numberBtn: numberText)
    }

    func calculatorViewDelegateTappedAdditionButton() {
        handleOperation(sign: "+")
    }

    func calculatorViewDelegateTappedSubstractionButton() {
        handleOperation(sign: "-")
    }

    func calculatorViewDelegateTappedEqualButton() {
        tappedEqualButton()

    }
}

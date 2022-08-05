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
    var calculModel: CalculModel = CalculModel()

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculatorView.delegate = self
    }

    // View actions
    func tappedNumberButton(numberBtn: String?) {
        calculModel.text = calculatorView.textView.text
        if let unwrappedNumberBtn = numberBtn {
            if calculModel.expressionHaveResult || calculatorView.textView.text == "0" {
                calculatorView.textView.text = ""
            }
            calculatorView.textView.text.append(unwrappedNumberBtn)
        }
    }

    func handleOperation(sign: String) {
        calculModel.text = calculatorView.textView.text
        if calculModel.canAddOperator {
            calculatorView.textView.text.append(" \(sign) ")
        } else {
            return self.present(alertService.alertError(alertType: .duplicateOperator),
                                animated: true, completion: nil)
        }
    }

    func tappedEqualButton() {
        calculModel.text = calculatorView.textView.text
        guard calculModel.expressionIsCorrect else {
            return self.present(alertService.alertError(alertType: .notEnoughElement),
                                animated: true, completion: nil)
        }
        guard calculModel.expressionHaveEnoughElement else {
            return self.present(alertService.alertError(alertType: .uncorrectExpression),
                                animated: true, completion: nil)
        }
        var result = calculModel.equalOperation()
        calculatorView.textView.text.append(" = \(result)")
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

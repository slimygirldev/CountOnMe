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
        calculatorView.delegate = self
    }

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
        let canDoOperation = calculModel.expressionIsCorrect
        if canDoOperation {
            calculatorView.textView.text.append(" \(sign) ")
        } else {
            return self.present(alertService.alertError(alertType: .duplicateOperator),
                                animated: true, completion: nil)
        }
    }

    func tappedClearButton() {
        calculModel.allClear()
        calculatorView.textView.text = ""
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
        // Risque de crash  - a mettre dans un try catch
        do {
            let result = try calculModel.equalOperation()
            calculatorView.textView.text = result
        } catch CalculationError.invalideExpression {
            self.present(alertService.alertError(alertType: .uncorrectExpression),
                                animated: true, completion: nil)
            print("Error alert calculation by 0")
        } catch CalculationError.divisionByZero {

        } catch {
            print("Unexpected error: \(error).")
        }
    }

}
extension ViewController: CalculatorViewDelegate {
    func calculatorViewDelegateTappedClearButton() {
        tappedClearButton()
    }

    func calculatorViewDelegateTappedDivideButton() {
        handleOperation(sign: Operation.divide.rawValue)
    }

    func calculatorViewDelegateTappedMultiplyButton() {
        handleOperation(sign: Operation.multiply.rawValue)
    }

    func calculatorViewDelegateTappedNumberButton(numberText: String?) {
        tappedNumberButton(numberBtn: numberText)
    }

    func calculatorViewDelegateTappedAdditionButton() {
        handleOperation(sign: Operation.add.rawValue)
    }

    func calculatorViewDelegateTappedSubstractionButton() {
        handleOperation(sign: Operation.substract.rawValue)
    }

    func calculatorViewDelegateTappedEqualButton() {
        tappedEqualButton()

    }
}

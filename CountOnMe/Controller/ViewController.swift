//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet var calculatorView: CalculatorView!

    private let alertService: AlertProvider = AlertProvider()
    let calculModel: CalculModel = CalculModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorView.delegate = self
    }

    // MARK: - Operation

    func tappedNumberButton(numberBtn: String?) {
        calculModel.setCalculationText(calculatorView.getCaclulatorText())
        if let unwrappedNumberBtn = numberBtn {
            if calculModel.shouldResetView() == true {
                calculatorView.changeCalculatorText(text: "")
            }
            calculatorView.appendCalculatortext(textToAppend: unwrappedNumberBtn)
        }
    }

    func handleOperation(sign: Operation) {
        calculModel.setCalculationText(calculatorView.getCaclulatorText())
        do {
            let operatorSign = try calculModel.canHandleOperation(sign: sign)
            calculatorView.appendCalculatortext(textToAppend: " \(operatorSign.rawValue) ")
        } catch CalculationError.invalidExpression {
            self.present(alertService.alertError(alertType: .invalidExpression),
                         animated: true, completion: nil)
        } catch CalculationError.duplicateOperator {
            self.present(alertService.alertError(alertType: .duplicateOperator),
                         animated: true, completion: nil)
        } catch {
            print("Unexpected error: \(error).")
        }
    }

    func tappedClearButton() {
        calculModel.allClear()
        calculatorView.changeCalculatorText(text: "")
    }

    func tappedEqualButton() {
        calculModel.setCalculationText(calculatorView.getCaclulatorText())
        do {
            let result = try calculModel.equalOperation()
            calculatorView.changeCalculatorText(text: result)
        } catch CalculationError.invalidExpression {
            self.present(alertService.alertError(alertType: .invalidExpression),
                         animated: true, completion: nil)
            print("Error invalid expression")
        } catch CalculationError.divisionByZero {
            self.present(alertService.alertError(alertType: .divisionByZero),
                         animated: true, completion: nil)
            tappedClearButton()
            print("Error alert calculation by 0")
        } catch CalculationError.notEnoughElement {
            self.present(alertService.alertError(alertType: .notEnoughElement),
                         animated: true, completion: nil)
            print("Error not enough elements")
        } catch {
            print("Unexpected error: \(error).")
        }
    }

}

// MARK: - CalculatorViewDelegate

extension ViewController: CalculatorViewDelegate {
    func calculatorViewDelegateTappedClearButton() {
        tappedClearButton()
    }

    func calculatorViewDelegateTappedDivideButton() {
        handleOperation(sign: Operation.divide)
    }

    func calculatorViewDelegateTappedMultiplyButton() {
        handleOperation(sign: Operation.multiply)
    }

    func calculatorViewDelegateTappedNumberButton(numberText: String?) {
        tappedNumberButton(numberBtn: numberText)
    }

    func calculatorViewDelegateTappedAdditionButton() {
        handleOperation(sign: Operation.add)
    }

    func calculatorViewDelegateTappedSubstractionButton() {
        handleOperation(sign: Operation.substract)
    }

    func calculatorViewDelegateTappedEqualButton() {
        tappedEqualButton()
    }
}

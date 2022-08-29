//
//  AlertProvider.swift
//  CountOnMe
//
//  Created by Lorene Brocourt on 02/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit

enum AlertMessage: String {
    case duplicateOperator = "Operator already entered."
    case uncorrectExpression = "Expression is not corect, please enter valide expression."
    case notEnoughElement = "Not enought elements in expression."
    case invalidExpression = "Wrong expression, please enter valide expression."
    case divisionByZero = "Dividing by zero impossible."
}
class AlertProvider: Error {

    func alertError(alertType: CalculationError) -> UIAlertController {
        switch alertType {
        case .duplicateOperator:
            let alertVC = UIAlertController(title: "Erreur",
                                            message: AlertMessage.duplicateOperator.rawValue, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        case .uncorrectExpression:
            let alertVC = UIAlertController(title: "Erreur",
                                            message: AlertMessage.uncorrectExpression.rawValue, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        case .notEnoughElement:
            let alertVC = UIAlertController(title: "Erreur",
                                            message: AlertMessage.notEnoughElement.rawValue,
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        case .invalidExpression:
            let alertVC = UIAlertController(title: "Erreur",
                                            message: AlertMessage.invalidExpression.rawValue, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        case .divisionByZero:
            let alertVC = UIAlertController(title: "Erreur",
                                            message: AlertMessage.divisionByZero.rawValue, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        }
    }
}

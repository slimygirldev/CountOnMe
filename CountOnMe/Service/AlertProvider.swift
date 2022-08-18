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
    case duplicateOperator = "Un operateur est déja mis !"
    case uncorrectExpression = "Entrez une expression correcte !"
    case notEnoughElement = "Il n'y a pas assez d'éléments pour faire le calcul."
    case invalidExpression = "L'expression est incorrecte"
    case divisionByZero = "Division par zéro impossible."
}
class AlertProvider: Error {

    func alertError(alertType: CalculationError) -> UIAlertController {
        switch alertType {
        case .duplicateOperator:
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: AlertMessage.duplicateOperator.rawValue, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        case .uncorrectExpression:
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: AlertMessage.uncorrectExpression.rawValue, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        case .notEnoughElement:
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: AlertMessage.notEnoughElement.rawValue,
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        case .invalidExpression:
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: AlertMessage.invalidExpression.rawValue, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        case .divisionByZero:
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: AlertMessage.divisionByZero.rawValue, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        }
    }
}

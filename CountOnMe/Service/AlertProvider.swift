//
//  AlertProvider.swift
//  CountOnMe
//
//  Created by Lorene Brocourt on 02/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit

class AlertProvider: Error {

    func alertError(alertType: CalculationError) -> UIAlertController {
        switch alertType {
        case .duplicateOperator:
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: "Un operateur est déja mis !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        case .uncorrectExpression:
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: "Entrez une expression correcte !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        case .notEnoughElement:
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: "Il n'y a pas assez d'éléments pour faire le calcul.",
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        case .invalidExpression:
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: "L'expression est incorrecte", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        case .divisionByZero:
            let alertVC = UIAlertController(title: "Zéro!",
                                            message: "Division par zéro impossible.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        }
    }
}

//
//  AlertProvider.swift
//  CountOnMe
//
//  Created by Lorene Brocourt on 02/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit

class AlertProvider {

    enum AlertType {
        case duplicateOperator
        case uncorrectExpression
        case notEnoughElement
    }

    func alertError(alertType: AlertType) -> UIAlertController {
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
                                            message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return alertVC
        }
    }
}

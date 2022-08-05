//
//  CalculModel.swift
//  CountOnMe
//
//  Created by Lorene Brocourt on 04/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation


struct CalculModel {
    var elements: [String] {
        // Separation of text into array for exemple :
        // 1 + 1 = 2
        // ["1", "+", "1", "=", "2"]
        return text.split(separator: " ").map { "\($0)" }
    }
    // equivaut calculatorView.textView.text
    // passerelle de communication netre controller en model
    // controller doit donner manuellement la valeur de text
    var text: String = ""

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
        // test me
        return text.firstIndex(of: "=") != nil
    }

    func equalOperation() -> String {
        // Create local copy of operations
        var operationsToReduce = elements
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            // operationtoreduce represente les elements
            // ex : ["1", "+", "1", "=", "2"]
            // represent la premiere entrée de l'array element
// FIXME: enlever les !
            let left = Int(operationsToReduce[0])!
            // repesent element position 1 in array
            let operand = operationsToReduce[1]
            // represent 3e entrée de array element
            let right = Int(operationsToReduce[2])!
            let result: Int

            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "÷":
                if right == 0 {
                    return ""
                } else {
                    result = left / right
                }
            case "x": result = left * right
            default:
                return ""
//                calculatorView.textView.text = ""
//                return self.present(alertService.alertError(alertType: .uncorrectExpression),
//                                  animated: true, completion: nil)
            }
            // cree nouvel array
            // dropFirts enleve les trois premier element de l'array
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            // insert le result à la place 0 de l'array
            operationsToReduce.insert("\(result)", at: 0)
        }
        return operationsToReduce.first!

    }
}

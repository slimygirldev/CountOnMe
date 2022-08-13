//
//  CalculModel.swift
//  CountOnMe
//
//  Created by Lorene Brocourt on 04/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation
enum CalculationError: Error {
    case divisionByZero
    case invalidExpression
    case notEnoughElement
    case duplicateOperator
    case uncorrectExpression
}

enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case divide = "÷"
    case equals = "="
}

struct CalculModel {
    // MARK: - Properties
    var text: String = ""
    var oldResult: Int = 0
    var current: Int? = 0
    var asAnOperation: Bool = false

    var elements: [String] {
        return text.split(separator: " ").map { "\($0)" }
    }

    var expressionIsCorrect: Bool {
        // empêcher de pouvoir entrer deux operator à la suite
        return elements.last != Operation.add.rawValue
        && elements.last != Operation.substract.rawValue
        && elements.last != Operation.divide.rawValue
        && elements.last != Operation.multiply.rawValue
    }

    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    var expressionHaveResult: Bool {
        let character: Character = Character(Operation.equals.rawValue)
        return text.firstIndex(of: character) != nil
    }
    // MARK: - Methods
    func canHandleOperation(sign: Operation) throws -> Operation {
        if expressionIsCorrect == true {
            return sign
        } else {
            throw CalculationError.invalidExpression
        }
    }
    func doOperation(left: Int, right: Int, sign: Operation) throws -> Int {
        let result: Int
        switch sign {
        case .add: result = left + right
        case .substract: result = left - right
        case .divide:
            if right == 0 {
                throw CalculationError.divisionByZero
            } else {
                result = left / right
            }
        case .multiply: result = left * right
        default:
            return 0
        }
        return result
    }

    mutating func equalOperation() throws -> String {
        if expressionIsCorrect != true {
            throw CalculationError.invalidExpression
        }
        if expressionHaveEnoughElement != true {
            throw CalculationError.notEnoughElement
        }
        var operationsToReduce = elements

        while operationsToReduce.count > 1 {
            guard let left = Int(operationsToReduce[0]) else {
                throw CalculationError.invalidExpression
            }
            guard let operand = Operation(rawValue: operationsToReduce[1]) else {
                throw CalculationError.invalidExpression
            }
            guard let right = Int(operationsToReduce[2]) else {
                throw CalculationError.invalidExpression
            }
            do {
                let result = try doOperation(left: left, right: right, sign: operand)
                current = result
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                operationsToReduce.insert("\(result)", at: 0)
            } catch {
                throw CalculationError.divisionByZero
            }
        }
        return operationsToReduce.first!
    }
    mutating func allClear() {
        self.text = ""
    }
}

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
    private var text: String = ""
    private var current: Int?
    private var asAnOperation: Bool = false

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
    mutating func setCalculationText(_ text: String) {
        self.text = text
    }
    func canExpressionHaveResult() -> Bool {
        if expressionHaveResult || text == "0" {
            return true
        }
        return false
    }

    mutating func isCurrentNil() -> Bool {
        if current == nil {
            return true
        } else {
            return false
        }
    }
    mutating func resetCurrent() {
        current = nil
    }
    mutating func canHandleOperation(sign: Operation) throws -> Operation {
        current = nil
        if expressionIsCorrect == true {
            return sign
        } else {
            throw CalculationError.invalidExpression
        }
    }
    func findPriorityIndex(array: [String]) -> Int {
        // multiply
        if let index = array.firstIndex(of: Operation.multiply.rawValue) {
            return index
        } else if let index = array.firstIndex(of: Operation.divide.rawValue) {
            return index
        }
        return -1
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
    mutating func prepareOperation(toReduce: [String], index: Int) throws -> Int {
        guard let left = Int(toReduce[index - 1]) else {
            throw CalculationError.invalidExpression
        }
        guard let operand = Operation(rawValue: toReduce[index]) else {
            throw CalculationError.invalidExpression
        }
        guard let right = Int(toReduce[index + 1]) else {
            throw CalculationError.invalidExpression
        }
        do {
            let result = try doOperation(left: left, right: right, sign: operand)
            current = result
            return result
        } catch {
            throw CalculationError.divisionByZero
        }
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
            // checking if there is a multiply priority in calculation
            let index = findPriorityIndex(array: operationsToReduce)
            if index != -1 {
                do {
                    let result = try prepareOperation(toReduce: operationsToReduce, index: index)
                    operationsToReduce.remove(at: index + 1)
                    operationsToReduce.remove(at: index)
                    operationsToReduce.remove(at: index - 1)
                    // pour gérer les cas où la prio est au milieu d'un calcul
                    // pour eviter le shift de placement dans l'array, supp par la fin
                    // et on place le resulat à la place avant la position de l'operator (index)
                    // pour s'assurer qu'il est bien 
                    operationsToReduce.insert("\(result)", at: index - 1)
                } catch {
                    throw CalculationError.divisionByZero
                }
            } else {
                do {
                    let result = try prepareOperation(toReduce: operationsToReduce, index: 1)
                    operationsToReduce = Array(operationsToReduce.dropFirst(3))
                    operationsToReduce.insert("\(result)", at: 0)
                } catch {
                    throw CalculationError.divisionByZero
                }
            }
        }
        return operationsToReduce.first!
    }
    mutating func allClear() {
        self.text = ""
    }
}

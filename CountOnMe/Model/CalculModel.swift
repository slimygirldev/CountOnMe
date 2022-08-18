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
    private(set) var text: String = ""
    private var current: Double?
    private var asAnOperation: Bool = false

    private var elements: [String] {
        return text.split(separator: " ").map { "\($0)" }
    }

    private var expressionIsCorrect: Bool {
        // empêcher de pouvoir entrer deux operator à la suite
        return elements.last != Operation.add.rawValue
        && elements.last != Operation.substract.rawValue
        && elements.last != Operation.divide.rawValue
        && elements.last != Operation.multiply.rawValue
    }

    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    private var expressionHaveResult: Bool {
        // cree character "="
        let character: Character = Character(Operation.equals.rawValue)
        return text.firstIndex(of: character) != nil
    }
    // MARK: - Methods
    mutating func setCalculationText(_ text: String) {
        self.text = text
    }
    // check if the user choices can end up to a calculation result
    func canExpressionHaveResult() -> Bool {
        if expressionHaveResult || text == "0" {
            return true
        }
        return false
    }
    // checking if current has a value
    mutating private func isCurrentNil() -> Bool {
        if current == nil {
            return true
        } else {
            return false
        }
    }
    mutating func shouldResetView() -> Bool {
        // nettoyer current
        if isCurrentNil() == false {
            resetCurrent()
            return true
        }
        // nettoyer le text
        if canExpressionHaveResult() {
            return true
        }
        return false
    }
    // reset current value to nil
    mutating private func resetCurrent() {
        current = nil
    }
    // checking if user entry can lead to a valid operation
    mutating func canHandleOperation(sign: Operation) throws -> Operation {
        current = nil
        if expressionIsCorrect == true {
            return sign
        } else {
            throw CalculationError.invalidExpression
        }
    }
    // checking for priority calculation in expression
    private func findPriorityIndex(array: [String]) -> Int {
        if let index = array.firstIndex(of: Operation.multiply.rawValue) {
            return index
        } else if let index = array.firstIndex(of: Operation.divide.rawValue) {
            return index
        }
        return -1
    }
    private func isInteger(_ result: Double) -> Bool {
        // permet de voir si il y a des chiffres après la virgule (decimal)
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return true
        } else {
            return false
        }
    }
    // separation des
    func createDoubleElementForOperation(array: [String], index: Int) throws -> Double {
        guard let element = Double(array[index]) else {
            throw CalculationError.invalidExpression
        }
        return element
    }
    func createOperatorElementForOperation(array: [String], index: Int) throws -> Operation {
        guard let operatorElement = Operation(rawValue: array[index]) else {
            throw CalculationError.invalidExpression
        }
        return operatorElement
    }

    // method who prepare operation
    mutating private func prepareOperation(toReduce: [String], index: Int) throws -> Double {
        do {
            let left = try createDoubleElementForOperation(array: toReduce, index: index - 1)
            let operand = try createOperatorElementForOperation(array: toReduce, index: index)
            let right = try createDoubleElementForOperation(array: toReduce, index: index + 1)

            let result = try doOperation(left: left,
                                         right: right,
                                         sign: operand)
            current = result
            return result
        } catch {
            throw CalculationError.divisionByZero
        }
    }
    // calculation logic
    private func doOperation(left: Double, right: Double, sign: Operation) throws -> Double {
        let result: Double
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

    private func transformDoubleResultIntoInteger(_ finalResult: String?) throws -> String {
        // unwrapping operationToReduce.firts qui est optionnel
        // puis unwrappe result qui est un Double optionnel
        // c'est une succession de if let en condensé, plus facile à lire
        if let finalResult = finalResult,
           let result: Double = Double(finalResult) {
            if isInteger(result) {
                // transformation du resultat double (ex: 3.0) en entier (3)
                let intergerResult: Int = Int(result)
                // transforme notre resultat Int en String en l'inbriquant dans un string
                return "\(intergerResult)"
            } else {
                // resultat avec un decimal valide (ex : 3.5)
                return finalResult
            }
        }
        throw CalculationError.invalidExpression
    }
    mutating func equalOperation() throws -> String {
        // checking errors of user entry
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
        do {
            let finalResult = try transformDoubleResultIntoInteger(operationsToReduce.first)
            return finalResult
        } catch {
            throw CalculationError.invalidExpression
        }
    }
    mutating func allClear() {
        self.text = ""
    }
}

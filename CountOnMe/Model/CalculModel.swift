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
        // prevent to enter two operator consecutively
        return elements.last != Operation.add.rawValue
        && elements.last != Operation.substract.rawValue
        && elements.last != Operation.divide.rawValue
        && elements.last != Operation.multiply.rawValue
    }

    private var expressionHaveEnoughElement: Bool {
        // check if the expression has a necessary of minimum 3 operands
        return elements.count >= 3
    }

    private var expressionHaveResult: Bool {
        // create equal character
        let character: Character = Character(Operation.equals.rawValue)
        return text.firstIndex(of: character) != nil
    }

    // MARK: - Methods
    mutating func setCalculationText(_ text: String) {
        self.text = text
    }

    func canExpressionHaveResult() -> Bool {
        // check if the user choices can end up to a calculation result
        if expressionHaveResult || text == "0" {
            return true
        }
        return false
    }

    mutating private func isCurrentNil() -> Bool {
        // checking if current has a value
        if current == nil {
            return true
        } else {
            return false
        }
    }

    mutating func shouldResetView() -> Bool {
        // clean current
        if isCurrentNil() == false {
            resetCurrent()
            return true
        }
        // clean text
        if canExpressionHaveResult() {
            return true
        }
        return false
    }

    mutating private func resetCurrent() {
        // checking if user entry can lead to a valid operation
        current = nil
    }

    mutating func canHandleOperation(sign: Operation) throws -> Operation {
        // checking if user entry can lead to a valid operation
        current = nil
        if text == "" {
            throw CalculationError.invalidExpression
        }
        if expressionIsCorrect == true {
            return sign
        } else {
            throw CalculationError.duplicateOperator
        }
    }

    // MARK: - Operation methods

    private func findPriorityIndex(array: [String]) -> Int {
        // checking for priority calculation in expression
        if let index = array.firstIndex(of: Operation.multiply.rawValue) {
            return index
        } else if let index = array.firstIndex(of: Operation.divide.rawValue) {
            return index
        }
        return -1
    }

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

    mutating private func prepareOperation(toReduce: [String], index: Int) throws -> Double {
        // method who prepare operation
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

    private func doOperation(left: Double, right: Double, sign: Operation) throws -> Double {
        // calculation logic
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
                    // moving index position of values to prevent calculation error with shifting problem
                    let result = try prepareOperation(toReduce: operationsToReduce, index: index)
                    operationsToReduce.remove(at: index + 1)
                    operationsToReduce.remove(at: index)
                    operationsToReduce.remove(at: index - 1)
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
        let finalResult = transformDoubleResultIntoInteger(operationsToReduce.first)
        return finalResult
    }

    // MARK: - Gestion of Number

    private func isInteger(_ result: Double) -> Bool {
        // checking if there is integer after decimal)
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            return true
        } else {
            return false
        }
    }

    private func transformDoubleResultIntoInteger(_ finalResult: String?) -> String {
        if let finalResult = finalResult,
           let result: Double = Double(finalResult) {
            if isInteger(result) {
                // transform decimal result into Int if there is 0 after the floating point
                return String(format: "%.0f", result)
            } else {
                // return decimal result
                return finalResult
            }
        }
        return ""
    }

    // MARK: - Clear
    mutating func allClear() {
        self.text = ""
    }
}

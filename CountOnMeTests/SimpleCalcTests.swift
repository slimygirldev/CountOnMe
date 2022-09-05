//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
    var model: CalculModel = CalculModel()

    // MARK: - Addition
    func testGivenCalculation_WhenAddition_ThenSuccessAddition() {
        model.setCalculationText("1 \(Operation.add.rawValue) 1")

        let result = try? model.equalOperation()

        XCTAssertTrue(result == "2")
    }

    func testGivenCalculation_WhenAddition_ThenFailAddition() {
        model.setCalculationText("1 \(Operation.add.rawValue) 1")

        let result = try? model.equalOperation()

        XCTAssertFalse(result == "3")
    }
    func testGivenCalculation_WhenExpressionIsFalse_ThenCatchInvalidExpression() {
        model.setCalculationText("1 \(Operation.add.rawValue) \(Operation.substract.rawValue)")

        XCTAssertThrowsError(try model.equalOperation()) { error in
            XCTAssertEqual(error as? CalculationError, CalculationError.invalidExpression)
        }
    }

    func testGivenCalculation_WhenExpressionHasEnoughElementsIsFalse_ThenCatchNotEnoughElement() {
        model.setCalculationText("1")

        XCTAssertThrowsError(try model.equalOperation()) { error in
            XCTAssertEqual(error as? CalculationError, CalculationError.notEnoughElement)
        }
    }
    // MARK: - Substraction
    func testGivenCalculation_WhenSubstraction_ThenSuccessSubstraction() {
        model.setCalculationText("1 \(Operation.substract.rawValue) 1")

        let result = try? model.equalOperation()

        XCTAssertTrue(result == "0")
    }

    func testGivenCalculation_WhenSubstraction_ThenFailSubstraction() {
        model.setCalculationText("1 \(Operation.substract.rawValue) 1")

        let result = try? model.equalOperation()

        XCTAssertFalse(result == "2")
    }
    // MARK: - Multiply
    func testGivenCalculation_WhenMultiply_ThenSuccessMultiply() {
        model.setCalculationText("1 \(Operation.multiply.rawValue) 2")

        let result = try? model.equalOperation()

        XCTAssertTrue(result == "2")
    }

    func testGivenCalculation_WhenMultiply_ThenFailMultiply() {
        model.setCalculationText("1 \(Operation.multiply.rawValue) 2")

        let result = try? model.equalOperation()

        XCTAssertFalse(result == "3")
    }
    // MARK: - Division
    func testGivenCalculation_WhenDivide_ThenSuccessDivide() {
        model.setCalculationText("2 \(Operation.divide.rawValue) 2")

        let result = try? model.equalOperation()

        XCTAssertTrue(result == "1")
    }

    func testGivenCalculation_WhenDivide_ThenFailDivide() {
        model.setCalculationText("2 \(Operation.divide.rawValue) 2")

        let result = try? model.equalOperation()

        XCTAssertFalse(result == "0")
    }

    func testGivenCalculationWithDouble_WhenDivide_ThenSuccesDivide() {
        model.setCalculationText("3 \(Operation.divide.rawValue) 2")

        let result = try? model.equalOperation()

        XCTAssertTrue(result == "1.5")
    }

    func testGivenCalculation_WhenDivideByZero_ThenCatchFailDivide() {
        model.setCalculationText("2 \(Operation.divide.rawValue) 0")

        model.setCalculationText("0 \(Operation.divide.rawValue) 0")

        XCTAssertThrowsError(try model.equalOperation()) { error in
            XCTAssertEqual(error as? CalculationError, CalculationError.divisionByZero)
        }
    }
    // MARK: - Priority
    func testGivenCalculationWithPriority_WhenDoOperationFindPriority_ThenSuccessCalculation() {
        model.setCalculationText(
            "3 \(Operation.add.rawValue) 2 \(Operation.multiply.rawValue) 2 \(Operation.divide.rawValue) 2")

        let result = try? model.equalOperation()

        XCTAssertTrue(result == "5")
    }

    func testGivenCalculationWithBigNumbers_WhenDoOperationFindPriorityAndHandleBigNumbers_ThenSuccessCalculation() {
        model.setCalculationText(
            "999554 \(Operation.add.rawValue) 9956 \(Operation.multiply.rawValue) 2244")

        let result = try? model.equalOperation()

        XCTAssertTrue(result == "2.33408e+07")
    }

    func testGivenCalculationWithError_WhenDoOperationFindPriority_ThenCatchInvalideExpression() {
        model.setCalculationText("2 \(Operation.multiply.rawValue) 3 3 \(Operation.substract.rawValue) 2")

        XCTAssertThrowsError(try model.equalOperation()) { error in
            XCTAssertEqual(error as? CalculationError, CalculationError.divisionByZero)
        }
    }

    // MARK: - Logic
    func testGivenOperationToPrepare_WhenUnwrappingElements_ThenSuccessCalculationElementsPrepare() {
        let operation =  ["1", "+", "4"]

        let left = try? model.createDoubleElementForOperation(array: operation, index: 0)
        let operationElement = try? model.createOperatorElementForOperation(array: operation, index: 1)
        let right = try? model.createDoubleElementForOperation(array: operation, index: 2)

        XCTAssert(operationElement == Operation.add)
        XCTAssert(left == 1)
        XCTAssert(right == 4)
    }

    func testGivenUnvalideOperatorForCalculation_WhenTryCreateOperatorElement_ThenCatchErrorInvalideExpression() {
        XCTAssertThrowsError(try model.createOperatorElementForOperation(array: ["1"], index: 0)) { error in
            XCTAssertEqual(error as? CalculationError, CalculationError.invalidExpression)
        }
    }

    func testGivenUnvalideOperandsForCalculation_WhenTryCreateOperandElements_ThenCatchErrorInvalideExpression() {
        XCTAssertThrowsError(try model.createDoubleElementForOperation(array: ["e"], index: 0)) { error in
            XCTAssertEqual(error as? CalculationError, CalculationError.invalidExpression)
        }
    }

    func testGivenCalculation_WhenSetCalculationTextIsZero_ThenSuccessResetView() {
        model.setCalculationText("0")

        let reset = model.shouldResetView()

        XCTAssertTrue(reset)
    }

    func testGivenCalculation_WhenSetCalculationTextIsEqual_ThenSuccessResetView() {
        model.setCalculationText("=")

        let reset = model.shouldResetView()

        XCTAssertTrue(reset)
    }

    func testGivenCalculation_WhenIsCurrentNotNil_ThenSuccessResetView() {
        model.setCalculationText("1 \(Operation.add.rawValue) 1")
        _ = try? model.equalOperation()

        let reset = model.shouldResetView()

        XCTAssertTrue(reset)
    }

    func testGivenSetCalculationText_WhenCanHandleOperationIsTrue_ThenExpressionIsCorrect() {
        model.setCalculationText("1")

        let operation = try?  model.canHandleOperation(sign: .add)

        XCTAssertEqual(operation, .add)
    }

    func testGivenExpressionIsNotCorrect_WhenExpressionIsFalse_ThenCatchFailCanHandleOperation() {
        model.setCalculationText("+")

        XCTAssertThrowsError(try model.canHandleOperation(sign: .divide)) { error in
            XCTAssertEqual(error as? CalculationError, CalculationError.duplicateOperator)
        }
    }

    func testGivenCalculationTextIsFilled_WhenAllClearUsed_ThenCalculationTextIsCleared() {
        model.setCalculationText("1")

        model.allClear()

        XCTAssert(model.text == "")
    }

    func testGivenCalculation_WhenExpressionHaveResultReturnFalse_ThenCanExpressionHaveResultReturnFalse() {
        model.setCalculationText("1")

        let result = model.canExpressionHaveResult()

        XCTAssertFalse(result)
    }
}

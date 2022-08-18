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
        //        do {
        //            _ = try model.equalOperation()
        //        } catch CalculationError.divisionByZero {
        //            XCTAssert(true)
        //        } catch {
        //            XCTAssert(false)
        //        }
        XCTAssertThrowsError(try model.equalOperation()) { error in
            XCTAssertEqual(error as? CalculationError, CalculationError.divisionByZero)
        }
    }
    // MARK: - Logic
    func testGivenCalculation_WhenSetCalculationTextIsZero_ThenSuccessResetView() {
        // Given
        model.setCalculationText("0")

        // When
        let reset = model.shouldResetView()

        // Then
        XCTAssert(reset == true)
    }

    func testGivenCalculation_WhenSetCalculationTextIsEqual_ThenSuccessResetView() {
        // Given
        model.setCalculationText("=")

        // When
        let reset = model.shouldResetView()

        // Then
        XCTAssert(reset == true)
    }

    func testGivenCalculation_WhenIsCurrentNotNil_ThenSuccessResetView() {
        // Given
        model.setCalculationText("1 \(Operation.add.rawValue) 1")
        _ = try? model.equalOperation()

        // When
        let reset = model.shouldResetView()

        // Then
        XCTAssert(reset == true)
    }

    func testGivenSetCalculationText_WhenCanHandleOperationIsTrue_ThenExpressionIsCorrect() {
        // Given
        model.setCalculationText("1")
        // When
        let operation = try?  model.canHandleOperation(sign: .add)
        // Then
        XCTAssert(operation == .add)
    }

    func testGivenExpressionIsNotCorrect_WhenExpressionIsFalse_ThenCatchFailCanHandleOperation() {
        model.setCalculationText("+")
        XCTAssertThrowsError(try model.canHandleOperation(sign: .divide)) { error in
            XCTAssertEqual(error as? CalculationError, CalculationError.invalidExpression)
        }
    }

    func testGivenCalculationTextIsFilled_WhenAllClearUsed_ThenCalculationTextIsCleared() {
        // Given
        model.setCalculationText("1")
        // When
        model.allClear()
        // Then
        XCTAssert(model.text == "")
    }
}

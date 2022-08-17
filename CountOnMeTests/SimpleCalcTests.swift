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
}

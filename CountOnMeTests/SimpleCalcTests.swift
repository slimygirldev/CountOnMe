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

    func testAddition() {
        model.setCalculationText("1 + 1")
        let result = try? model.equalOperation()

        XCTAssertTrue(result == "2")
    }
}

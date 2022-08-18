//
//  AlertProviderTest.swift
//  CountOnMeTests
//
//  Created by Lorene Brocourt on 17/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class AlertProviderTest: XCTestCase {
    let alertService: AlertProvider = AlertProvider()

    func testGivenAlertError_WhenInvalideExpressionIsTriggerd_ThenPresentingInvalideExpressionAlert() {
        let alert = alertService.alertError(alertType: .invalidExpression)
        XCTAssert(alert.message == AlertMessage.invalidExpression.rawValue)
    }
    func testGivenAlertError_WhenDuplicateOperatorsTriggerd_ThenPresentingDuplicateOperatorAlert() {
        let alert = alertService.alertError(alertType: .duplicateOperator)
        XCTAssert(alert.message == AlertMessage.duplicateOperator.rawValue)
    }
    func testGivenAlertError_WhenUncorrectExpressionTriggerd_ThenPresentingUncorrectExpressionAlert() {
        let alert = alertService.alertError(alertType: .uncorrectExpression)
        XCTAssert(alert.message == AlertMessage.uncorrectExpression.rawValue)
    }
    func testGivenAlertError_WhenNotEnoughElementTriggerd_ThenPresentingNotEnoughElementAlert() {
        let alert = alertService.alertError(alertType: .notEnoughElement)
        XCTAssert(alert.message == AlertMessage.notEnoughElement.rawValue)
    }
    func testGivenAlertError_WhenDivisionByZeroTriggerd_ThenPresentingDivisionByZeroAlert() {
        let alert = alertService.alertError(alertType: .divisionByZero)
        XCTAssert(alert.message == AlertMessage.divisionByZero.rawValue)
    }
}

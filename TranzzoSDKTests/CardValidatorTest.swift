//
//  CardValidatorTest.swift
//  TranzzoSDKTests
//
//  Created by user on 1/14/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import XCTest
@testable import TranzzoSDK

class CardValidatorTest: XCTestCase {
    var sut: CardValidator!
    
    override func setUp() {
        super.setUp()
        sut = CardValidator()
    }
    
    func testGetCardType() {
        XCTAssertEqual(sut.getCardType(for: "4111 1111 1111 1111"), CardProvider.visa)
        XCTAssertEqual(sut.getCardType(for: "3782 822463 10005"), CardProvider.amex)
        XCTAssertEqual(sut.getCardType(for: "5555 5555 5555 4444"), CardProvider.mastercard)
        XCTAssertEqual(sut.getCardType(for: "6759 6498 2643 8453"), CardProvider.maestro)
        XCTAssertEqual(sut.getCardType(for: "4111111111111111"), CardProvider.visa)
        XCTAssertNil(sut.getCardType(for: "411111111111"))
    }
    
    func testIsValidCardNumber() {
        XCTAssertTrue(sut.isValid(cardNumber: "4111 1111 1111 1111"))
        XCTAssertFalse(sut.isValid(cardNumber: "4111 1111 1111"))
        XCTAssertTrue(sut.isValid(cardNumber: "6799990100000000019"))
    }
    
    func testIsValidCardNumberForProvider() {
        XCTAssertTrue(sut.isValid(cardNumber: "4111 1111 1111 1111", for: .visa))
        XCTAssertTrue(sut.isValid(cardNumber: "4111111111111111", for: .visa))
        XCTAssertFalse(sut.isValid(cardNumber: "4111111111111111", for: .amex))
    }
    
    func testIsValidCVVForProvider() {
        XCTAssertTrue(sut.isValid(cvv: "123", for: .visa))
        XCTAssertTrue(sut.isValid(cvv: "1234", for: .amex))
        XCTAssertFalse(sut.isValid(cvv: "1234", for: .mastercard))
    }
    
    func testIsValidExpirationDate() {
        let currentDate = Date()
        let year = Calendar.current.component(.year, from: currentDate)
        let month = Calendar.current.component(.month, from: currentDate)
        XCTAssertFalse(sut.isValid(expirationDate: CardExpirationDate(month: 1, year: year - 8)))
        XCTAssertFalse(sut.isValid(expirationDate: CardExpirationDate(month: 0, year: year - 8)))
        XCTAssertFalse(sut.isValid(expirationDate: CardExpirationDate(month: month - 1, year: year)))
        XCTAssertTrue(sut.isValid(expirationDate: CardExpirationDate(month: month + 1, year: year)))
        XCTAssertFalse(sut.isValid(expirationDate: CardExpirationDate(month: 0, year: year)))
        XCTAssertTrue(sut.isValid(expirationDate: CardExpirationDate(month: month + 1, year: year + 8)))
        XCTAssertFalse(sut.isValid(expirationDate: CardExpirationDate(month: 0, year: year + 8)))
    }
}

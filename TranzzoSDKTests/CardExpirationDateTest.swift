//
//  CardExpirationDateTest.swift
//  TranzzoSDKTests
//
//  Created by user on 15.01.2020.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import XCTest
@testable import TranzzoTokenizer

class CardExpirationDateTest: XCTestCase {
    func testInitFromRawDateString() {
        let rawDateString = "04/24"
        var date = try? CardExpirationDate(rawDateString: rawDateString)
        XCTAssertEqual(date?.month, 4)
        XCTAssertEqual(date?.year, 24)
        let rawDateStringLong = "04/2024"
        date = try? CardExpirationDate(rawDateString: rawDateStringLong)
        XCTAssertEqual(date?.month, 4)
        XCTAssertEqual(date?.year, 24)
        let rawDateStringTooLong = "4/202424"
        date = try? CardExpirationDate(rawDateString: rawDateStringTooLong)
        XCTAssertEqual(date?.month, 4)
        XCTAssertEqual(date?.year, 24)
        let rawDateStringInvalid = "04"
        date = try? CardExpirationDate(rawDateString: rawDateStringInvalid)
        XCTAssertNil(date)
    }
}

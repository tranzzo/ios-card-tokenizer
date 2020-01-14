//
//  DataEncoderTest.swift
//  TranzzoSDKTests
//
//  Created by user on 1/14/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import XCTest
@testable import TranzzoSDK

class DataEncoderTest: XCTestCase {
    var sut: DataEncoder!
    
    override func setUp() {
        super.setUp()
        sut = DataEncoder()
    }
    
    func testStringEncode() {
        let card = TestHelpers.MockRequstData(b: "2", a: "1", c: "3")
        let string = sut.stringEncode(card)
        XCTAssertEqual("123", string)
    }

}

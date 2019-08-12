/*
 * Copyright (c) TRANZZO LTD - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

import XCTest
@testable import widget_light_sdk

class CryptoTest: XCTestCase {
    var utils = CommonUtils()
    
    struct MockRequstData: Codable {
        public let a: String
        public let b: String
        public let c: String
    }

    func testHmacSign() {
        let mockData = MockRequstData(a: "1", b: "2", c: "3")
        let dataToString: String = utils.stringBuilder(params: mockData)!
        let sign = dataToString.hmac(key: "secret")
        XCTAssertEqual("77de38e4b50e618a0ebb95db61e2f42697391659d82c064a5f81b9f48d85ccd5", sign)
    }




}

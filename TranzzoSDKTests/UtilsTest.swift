/*
 * Copyright (c) TRANZZO LTD - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

import XCTest
@testable import TranzzoSDK

class UtilsTest: XCTestCase {
    let utils = CommonUtils()
    
    struct DataMock: Codable, Equatable {
        let b: String
        let a: String
        let c: String
        var rich: Bool? = false
    }

    func testJSONDecoder() throws {
        let decodedJson = try utils.jsonDecoder.decode(DataMock.self, from: fixture)
        let data = DataMock(b: "b", a: "a", c: "c")
        XCTAssertEqual(data, decodedJson)
    }

    func testSerializeUnsortedData() {
        let data = DataMock(b: "2", a: "1", c: "3", rich: true)
        XCTAssertEqual(utils.stringBuilder(params: data), "123true")
    }
}

private let fixture = Data("""
{
 "a": "a",
 "b": "b",
 "c": "c",
 "rich": true
}
""".utf8)

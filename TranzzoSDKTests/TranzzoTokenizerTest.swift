//
//  TranzzoTokenizerTest.swift
//  widget-light-sdkTests
//
//  Created by Vladislav Taiurskyi on 8/12/19.
//  Copyright © 2019 Tranzzo. All rights reserved.
//

import XCTest
@testable import TranzzoSDK

class TranzzoTokenizerTest: XCTestCase {
    var sut: TranzzoTokenizer!
    var card: CardRequestData!
    var invalidCard: CardRequestData!

    let apiToken = "m03z1jKTSO6zUYQN5C8xYZnIclK0plIQ/3YMgTZbV6g7kxle6ZnCaHVNv3A11UCK"

    override func setUp() {
        super.setUp()
        sut = TranzzoTokenizer(apiToken: apiToken, environment: .stage)
        card = TestHelpers.createValidCardRequestData()
        invalidCard = TestHelpers.createInvalidCardRequestData()
    }
    
    func testMakeSuccessRequest() {
        let expectation = XCTestExpectation(description: "Get token")
        sut.tokenize(card: card) { (result: Result<TokenSuccessResponse, TranzzoError>) in
            switch result {
            case .success(let cardToken):
                print(cardToken)
                XCTAssertNotNil(cardToken)
                XCTAssertNotNil(cardToken.token)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }

    func testMakeEncryptSuccessRequest() {
        let expectation = XCTestExpectation(description: "Get encrypted token")
        sut.tokenizeEncrypt(card: card) { (result: Result<TokenEncryptSuccessResponse, TranzzoError>) in
            switch result {
            case .success(let cardToken):
                print(cardToken)
                XCTAssertNotNil(cardToken)
                XCTAssertNotNil(cardToken.data)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testMakeFailureRequest() {
        let expectation = XCTestExpectation(description: "Failure token")
        sut.tokenize(card: invalidCard) { (result: Result<TokenSuccessResponse, TranzzoError>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                print("Response error: \(error)")
                XCTAssertNotNil(error.message)
                expectation.fulfill()
            }
        }
        
         wait(for: [expectation], timeout: 3.0)
    }

    override func tearDown() {
        sut = nil
    }

}

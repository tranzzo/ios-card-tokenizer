//
//  TokenizeHttpApiTest.swift
//  widget-light-sdkTests
//
//  Created by Vladislav Taiurskyi on 8/12/19.
//  Copyright © 2019 Tranzzo. All rights reserved.
//

import XCTest
@testable import widget_light_sdk

class TokenizeHttpApiTest: XCTestCase {
    var api: TranzzoTokenizeApi!
    var card: CardTokenRequest!
    var cardNotValid: CardTokenRequest!

    let apiToken = "m03z1jKTSO6zUYQN5C8xYZnIclK0plIQ/3YMgTZbV6g7kxle6ZnCaHVNv3A11UCK"

    override func setUp() {
        super.setUp()
        api = TranzzoTokenizeApi(apiToken: apiToken, env: .stage)
        card = CardTokenRequest(cardNumber: "4242424242424242", cardExpMonth: 11, cardExpYear: 22, cardCvv: "123")
        cardNotValid = CardTokenRequest(cardNumber: "123", cardExpMonth: 22, cardExpYear: 22, cardCvv: "")
    }
    
    
    func testMakeSuccessRequest() {
        let expectation = XCTestExpectation(description: "Get token")
        api.tokenize(card: card) { (result: Result<TokenSuccessResponse, TokenApiError>) in
            switch result {
            case .success(let cardToken):
                print(cardToken)
                XCTAssertNotNil(cardToken)
                XCTAssertNotNil(cardToken.token)
                XCTAssertNotNil(cardToken.expiresAt)
                XCTAssertNotNil(cardToken.cardMask)
                XCTAssertEqual("424242******4242", cardToken.cardMask)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testMakeFailureRequest() {
        let expectation = XCTestExpectation(description: "Failure token")
        api.tokenize(card: cardNotValid) { (result: Result<TokenSuccessResponse, TokenApiError>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                print(error)
                XCTAssertNotNil(error.id)
                expectation.fulfill()

            }
        }
        
         wait(for: [expectation], timeout: 3.0)
    }

    override func tearDown() {
        api = nil
    }


}

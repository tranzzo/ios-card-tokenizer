//
//  TestHelpers.swift
//  TranzzoSDKTests
//
//  Created by user on 1/14/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation
@testable import TranzzoSDK

final class TestHelpers {
    struct MockRequstData: Encodable {
        let b: String
        let a: String
        let c: String
    }
    
    static func createValidCardRequestData() -> CardRequestData {
        return CardRequestData(cardNumber: "4242424242424242", cardExpMonth: 11, cardExpYear: 22, cardCvv: "123")
    }
    
    static func createInvalidCardRequestData() -> CardRequestData {
        CardRequestData(cardNumber: "4242424242424241", cardExpMonth: 22, cardExpYear: 22, cardCvv: "123")
    }
}

//
//  ErrorResponse.swift
//  TranzzoSDK
//
//  Created by user on 1/13/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    let id: String
    let errorMessage: String
    let hint: String?
}

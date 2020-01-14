//
//  Request.swift
//  TranzzoSDK
//
//  Created by user on 1/13/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
}

enum RequestData {
    case tokenize(card: CardRequestData)
    
    var path: String {
        switch self {
        case .tokenize:
            return "tokenize"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .tokenize:
            return .post
        }
    }
}

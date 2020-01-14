//
//  TranzzoError.swift
//  TranzzoSDK
//
//  Created by user on 1/13/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation

public struct TranzzoError: Error {
    public var id: String?
    public var hint: String? = ""
    public var message: String?
    
    public init(id: String,  message: String, hint: String?) {
        self.id = id
        self.hint = hint
        self.message = message
    }
    
    public init(message: String) {
        self.message = message
    }
}

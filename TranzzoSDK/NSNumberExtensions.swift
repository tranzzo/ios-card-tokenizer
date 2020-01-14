//
//  NSNumberExtensions.swift
//  TranzzoSDK
//
//  Created by user on 1/14/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation

extension NSNumber {
    var isBool: Bool {
        return type(of: self) == type(of: NSNumber(booleanLiteral: true))
    }
}

//
//  StringExtensions.swift
//  TranzzoSDK
//
//  Created by user on 1/14/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation

public extension String {
    var digitsOnly: String {
        return filter { $0.isNumber }
    }
}

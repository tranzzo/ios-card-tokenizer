//
//  DataEncoder.swift
//  TranzzoSDK
//
//  Created by user on 1/13/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation

final class DataEncoder: JSONEncoder {
    override init() {
        super.init()
        keyEncodingStrategy = .convertToSnakeCase
    }
}

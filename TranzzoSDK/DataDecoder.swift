//
//  DataDecoder.swift
//  TranzzoSDK
//
//  Created by user on 1/13/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation

final class DataDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}

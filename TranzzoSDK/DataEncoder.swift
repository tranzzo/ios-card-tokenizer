/*
* Copyright (c) TRANZZO LTD - All Rights Reserved
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
*/

import Foundation

final class DataEncoder: JSONEncoder {
    override init() {
        super.init()
        keyEncodingStrategy = .convertToSnakeCase
    }
}

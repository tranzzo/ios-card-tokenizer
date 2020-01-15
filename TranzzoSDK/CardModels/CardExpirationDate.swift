/*
* Copyright (c) TRANZZO LTD - All Rights Reserved
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
*/

import Foundation

public struct CardExpirationDate {
    let month: Int
    let year: Int
    
    public init(month: Int, year: Int) {
        self.month = month
        self.year = year
    }
}

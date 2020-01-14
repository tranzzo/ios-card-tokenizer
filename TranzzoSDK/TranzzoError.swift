/*
* Copyright (c) TRANZZO LTD - All Rights Reserved
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
*/

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

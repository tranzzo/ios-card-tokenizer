/*
* Copyright (c) TRANZZO LTD - All Rights Reserved
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
*/

import Foundation

struct ErrorResponse: Decodable {
    let id: String
    let errorMessage: String
    let hint: String?
}

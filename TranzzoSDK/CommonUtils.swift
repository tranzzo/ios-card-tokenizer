/*
 * Copyright (c) TRANZZO LTD - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */


import Foundation

class CommonUtils {
    var jsonEncoder: JSONEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        return jsonEncoder
    }
    
    var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
    
    
    func stringBuilder<T: Encodable>(params: T) -> String? {
        guard let encodedData = try? jsonEncoder.encode(params) else { return nil }
        let dictionary = (try? JSONSerialization.jsonObject(with: encodedData, options: .allowFragments))
            .flatMap { ($0 as! [String: Any]) }

        return dictionary!
            .sorted { $0.key < $1.key }
            .map { (key, value) in
                if key == "rich" {
                    return "\(Bool(truncating: value as! NSNumber))"
                }
                return "\(value)" }
            .joined(separator: "")
    }
}

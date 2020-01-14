//
//  URLRequestBuilder.swift
//  TranzzoSDK
//
//  Created by user on 1/13/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation

class URLRequestBuilder {
    static func createURLRequest(to host: String, requestData: RequestData) -> URLRequest? {
        guard let url = URL(string: host + requestData.path) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestData.method.rawValue
        self.setDefaultHeaders(to: &request)
        
        return request
    }
    
    private static func setDefaultHeaders(to request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XmlHttpRequest", forHTTPHeaderField: "X-Requested-With")
    }
}

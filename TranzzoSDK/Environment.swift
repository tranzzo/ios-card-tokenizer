//
//  Environment.swift
//  TranzzoSDK
//
//  Created by user on 1/13/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation

public enum Environment: String {
    case prod
    case stage
    
    // MARK: - Public Properties
    var baseURL: String {
        return scheme + "\(subdomain).\(domain)/\(groupPath)"
    }
    
    // MARK: - Private Properties
    private var scheme: String {
        return "https://"
    }
    
    private var subdomain: String {
        switch self {
        case .prod:
            return "widget"
        case .stage:
            return "widget-stg"
        }
    }
    
    private var domain: String {
        return "tranzzo.com"
    }
    
    private var groupPath: String {
        return "api/v1/sdk/"
    }
}

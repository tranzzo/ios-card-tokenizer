//
//  CardProvider.swift
//  TranzzoSDK
//
//  Created by user on 1/14/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation

/// Defines the rules for various card providers.
public enum CardProvider: String, CaseIterable {
    case mastercard
    case visa
    case maestro
    case amex
    
    /// Name of a card provider
    public var name: String {
        switch self {
        case .visa:
            return "Visa"
        case .mastercard:
            return "Mastercard"
        case .maestro:
            return "Maestro"
        case .amex:
            return "American Express"
        }
    }
    
    /// Regex pattern for card number to satisfy for the provider
    public var pattern: String {
        switch self {
        case .visa:
            return "^4[0-9]{12}(?:[0-9]{3})?$"
        case .mastercard:
            return "^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720)\\d*$"
        case .maestro:
            return "^(?:5[06789]\\d\\d|(?!6011[0234])(?!60117[4789])(?!60118[6789])(?!60119)(?!64[456789])(?!65)6\\d{3})\\d{8,15}$"
        case .amex:
            return "^3[47]\\d*$"
        }
    }
    
    /// Indeces of gaps expected in a card number for the provider
    public var gaps: [Int] {
        switch self {
            case .visa:
                return [4, 8, 12]
            case .mastercard:
                return [4, 8, 12]
            case .maestro:
                return [4, 8, 12]
            case .amex:
                return [4, 10]
        }
    }
    
    /// Valid length of a valid card number for the provider
    public var validLength: [Int] {
        switch self {
            case .visa:
                return [16]
            case .mastercard:
                return [16]
            case .maestro:
                return [12, 13, 14, 15, 16, 17, 18, 19]
            case .amex:
                return [14, 16, 19]
        }
    }
    
    /// Valid length of a valid card cvv for the provider
    public var validCVVLength: Int {
        switch self {
            case .visa:
                return 3
            case .mastercard:
                return 3
            case .maestro:
                return 3
            case .amex:
                return 4
        }
    }
}

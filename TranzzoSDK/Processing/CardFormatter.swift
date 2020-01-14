//
//  CardFormatter.swift
//  TranzzoSDK
//
//  Created by user on 1/14/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation
/// Type that provides various card  formatting methods
final class CardFormatter {
    /// Formats the card number to follow the rules of a specified provider
    ///
    /// - parameter cardNumber:          Input card number to format.
    /// - parameter provider:          `CardProvider`, that provides formatting rules.
    /// - Returns: Card number, that follows formatting rules of a specified provider
    public func format(cardNumber: String, for cardType: CardProvider) -> String {
        var index = 0
        var numberOfGaps = 0
        return cardNumber.reduce("") {
            defer { index += 1 }
            guard cardType.gaps.count > numberOfGaps else { return "\($0)\($1)" }
            if index == cardType.gaps[numberOfGaps] {
                numberOfGaps += 1
                return "\($0) \($1)"
            }
            return "\($0)\($1)"
        }
    }
    
    /// Formats the expiration date string to a standard format
    ///
    /// - parameter expiryDate:          Input expiration date string.
    /// - Returns: Card number, that follows formatting rules of a specified provider
    public func formatExpiryDate(_ expiryDate: String) -> CardExpirationDate? {
        let digitOnlyDate = expiryDate.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var month: Int?
        var year: Int?
        
        switch digitOnlyDate.count {
        case ...5:
            let indexEndMonth = digitOnlyDate.index(digitOnlyDate.startIndex, offsetBy: 2)
            month = Int(digitOnlyDate[..<indexEndMonth])
            year = Int(digitOnlyDate[indexEndMonth...])
        case 5...:
            let indexEndMonth = digitOnlyDate.index(digitOnlyDate.startIndex, offsetBy: 2)
            let indexStartYear = digitOnlyDate.index(digitOnlyDate.startIndex, offsetBy: 4)
            month = Int(digitOnlyDate[..<indexEndMonth])
            year = Int(digitOnlyDate[indexStartYear...])
        default:
            return nil
        }
        if let month = month, let year = year {
            return CardExpirationDate(month: month, year: year)
        } else {
            return nil
        }
    }
    
}

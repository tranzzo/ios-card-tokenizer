/*
* Copyright (c) TRANZZO LTD - All Rights Reserved
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
*/

import Foundation
/// Type that provides various card  formatting methods
final class CardFormatter {
    /// Formats the card number to follow the rules of a specified provider
    ///
    /// - parameter cardNumber:          Input card number to format.
    /// - parameter provider:          `CardProvider`, that provides formatting rules.
    /// - Returns: Card number, that follows formatting rules of a specified provider
    public func format(cardNumber: String, for cardType: CardProvider) -> String {
        var filteredNumber = cardNumber
        if filteredNumber.containsNonDigits {
            filteredNumber = filteredNumber.digitsOnly
        }
        var index = 0
        var numberOfGaps = 0
        return filteredNumber.reduce("") {
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

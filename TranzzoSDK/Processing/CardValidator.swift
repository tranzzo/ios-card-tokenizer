//
//  TranzzoCardValidator.swift
//  TranzzoSDK
//
//  Created by user on 1/14/20.
//  Copyright © 2020 Tranzzo. All rights reserved.
//

import Foundation
/// Type that provides methods to determine card providers and validate card data, such as number, cvv and expiry date
class CardValidator {
    // MARK: - Private Properties
    private let cardTypes = CardProvider.allCases
    
    // MARK: - Public Properties
    /// Determines the card provider by its number
    ///
    /// - parameter cardNumber:          Card number.
    /// - Returns: Fetched `CardProvider`, if specified number is valid, nil otherwise.
    public func getCardType(for cardNumber: String) -> CardProvider? {
        return cardTypes.first {
            cardNumber.range(of: $0.pattern, options: .regularExpression) != nil
        }
    }
    
    /// Determines, if the card number is valid
    ///
    /// - parameter cardNumber:          Card number to validate.
    /// - Returns: `true` if specified number is valid, `false` otherwise.
    public func isValid(cardNumber: String) -> Bool {
        if let cardType = self.getCardType(for: cardNumber) {
            return self.isValid(cardNumber: cardNumber, for: cardType)
        }
        return false
    }
    
    /// Determines, if the card number is valid for a specified provider
    ///
    /// - parameter cardNumber:          Card number to validate.
    /// - parameter provider:          `CardProvider`, that provides validation rules.
    /// - Returns: `true` if specified number is valid, `false` otherwise.
    public func isValid(cardNumber: String, for provider: CardProvider) -> Bool {
        guard luhnCheck(cardNumber: cardNumber) else { return false }
        return provider.validLength.contains { $0 == cardNumber.count }
    }
    
    /// Determines, if the cvv is valid for a specified provider
    ///
    /// - parameter cvv:          CVV to validate.
    /// - parameter provider:          `CardProvider`, that provides validation rules.
    /// - Returns: `true` if specified cvv is valid, `false` otherwise.
    public func isValid(cvv: String, for provider: CardProvider) -> Bool {
        return provider.validCVVLength == cvv.count
    }
    
    /// Determines, if the expiration date values are valid
    ///
    /// - parameter expirationMonth:          Expiration month for a card.
    /// - parameter expirationYear:           Expiration year for a card.
    /// - Returns: `true` if specified values are valid, `false` otherwise.
    public func isValid(expirationDate: CardExpirationDate) -> Bool {
        guard expirationDate.month > 0 else { return false }
        guard expirationDate.year > 0 else { return false }
        if expirationDate.month > 12 { return false }
        
        return true
    }
    
    // MARK: - Private Properties
    private func luhnCheck(cardNumber: String) -> Bool {
        var sum = 0
        let reversedCharacters = cardNumber.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
}

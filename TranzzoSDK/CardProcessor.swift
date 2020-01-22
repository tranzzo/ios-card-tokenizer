/*
* Copyright (c) TRANZZO LTD - All Rights Reserved
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
*/

import Foundation

public struct CardData: Equatable {
    public let type: CardType
    public let name: String
    public let pattern: String
    public let gaps: [Int]
    public let validLength: [Int]
    public let validCVVLength: [Int]
}

public enum CardType: String {
    case mastercard
    case visa
    case maestro
    case mir
    case prostir
    case unionpay
    case amex
}

struct TRZCardFormRawData {
    public let cardNumber: String
    public let cvv: String
    public let expiryDate: String
}

public class CardProcessor {
    let cardTypes: KeyValuePairs<CardType, CardData> = [
        .visa: CardData(
            type: .visa,
            name: "Visa",
            pattern: "^4[0-9]{12}(?:[0-9]{3})?$",
            gaps: [4, 8, 12],
            validLength: [16],
            validCVVLength: [3]
        ),
        .mastercard: CardData(
            type: .mastercard,
            name: "Mastercard",
            pattern: "^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720)\\d*$",
            gaps: [4, 8, 12],
            validLength: [16],
            validCVVLength: [3]
        ),
        .maestro: CardData(
            type: .maestro,
            name: "Maestro",
            pattern: "^(?:5[06789]\\d\\d|(?!6011[0234])(?!60117[4789])(?!60118[6789])(?!60119)(?!64[456789])(?!65)6\\d{3})\\d{8,15}$",
            gaps: [4, 8, 12],
            validLength: [12, 13, 14, 15, 16, 17, 18, 19],
            validCVVLength: [3]
        ),
        .amex: CardData(
            type: .amex,
            name: "American Express",
            pattern: "^3[47]\\d*$",
            gaps: [4, 10],
            validLength: [14, 16, 19],
            validCVVLength: [4]
        )
    ]
    
    public func luhnCheck(cardNumber: String) -> Bool {
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
    
    func getCardType(cardNumber: String) -> CardData? {
        for (_, card) in cardTypes {
            if cardNumber.range(of: card.pattern, options: .regularExpression) != nil {
                return card
            }
        }
        return nil
    }
    
    func format(cardNumber: String, card: CardData) -> String {
        var index = 0
        var numberOfGaps = 0
        return cardNumber.reduce("") {
            defer { index += 1 }
            guard card.gaps.count > numberOfGaps else { return "\($0)\($1)" }
            if index == card.gaps[numberOfGaps] {
                numberOfGaps += 1
                return "\($0) \($1)"
            }
            return "\($0)\($1)"
        }
    }
    
    func isValid(cardNumber: String) -> Bool {
        let card = self.getCardType(cardNumber: cardNumber)
        return card != nil ? self.isValid(cardNumber: cardNumber, card: card!) : false
    }
    
    func isValid(cardNumber: String, card: CardData) -> Bool {
        guard luhnCheck(cardNumber: cardNumber) else { return false }
        return card.validLength.contains { $0 == cardNumber.count }
    }
    
    func isValid(cvv: String, card: CardData) -> Bool {
        return card.validCVVLength.contains { $0 == cvv.count }
    }
    
    func isValid(expirationMonth: Int, expirationYear: Int) -> Bool {
        guard expirationMonth > 0 else { return false }
        guard expirationYear > 0 else { return false }
        if expirationMonth > 12 || expirationMonth < 1 { return false }
        
        return true
    }
    
    func onlyNumbers(cardNumber: String) -> String {
        return cardNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    func formatExpiryDate(expirationDate: String) -> (month: Int, year: Int)? {
        let digitOnlyDate = expirationDate.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        switch digitOnlyDate.count {
        case ...5:
            let indexEndMonth = digitOnlyDate.index(digitOnlyDate.startIndex, offsetBy: 2)
            let month = digitOnlyDate[..<indexEndMonth]
            let year = digitOnlyDate[indexEndMonth...]
            return (month: Int(month)!, year: Int(year)!)
        case 5...:
            let indexEndMonth = digitOnlyDate.index(digitOnlyDate.startIndex, offsetBy: 2)
            let indexStartYear = digitOnlyDate.index(digitOnlyDate.startIndex, offsetBy: 4)
            let month = digitOnlyDate[..<indexEndMonth]
            let year = digitOnlyDate[indexStartYear...]
            return (month: Int(month)!, year: Int(year)!)
        default:
            return nil
        }
    }
    
    func getCard(type: CardType) -> CardData? {
        return cardTypes.first(where: { $0.key == type})?.value
    }
    
    func formatCardRawData(card: TRZCardFormRawData) ->
        (cardNumber: String, expiryMonth: Int, expiryYear: Int, cvv: String) {
            let cardNumber = onlyNumbers(cardNumber: card.cardNumber)
            let (expiryMonth, expiryYear) = formatExpiryDate(expirationDate: card.expiryDate)!
            let cvv = card.cvv
            
            return (cardNumber, expiryMonth, expiryYear, cvv)
    }
}

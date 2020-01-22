#  TranzzoSDK Tokenizer

![CocoaPods Compatible](https://img.shields.io/cocoapods/v/TranzzoSDK.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/TranzzoSDK.svg?style=flat)](https://github.com/tranzzo/tranzzo-ios/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/Stripe.svg?style=flat)](https://github.com/tranzzo/tranzzo-ios#)
![Twitter](https://img.shields.io/badge/twitter-@TranzzoEU-blue.svg)

## Requirements

- iOS 9+
- Swift 5+

## Installation

### CocoaPods

To integrate TranzzoSDK into your Xcode project using [CocoaPods](https://cocoapods.org), add it to your `Podfile`:

```ruby
pod 'TranzzoSDK'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

To integrate TranzzoSDK into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), add it to your `Cartfile`:

```
binary "https://bitbucket.org/tranzzo/ios-widget-light-sdk.git"
```

Then, run the following command:

```bash
$ carthage update
```

Then drag TranzzoSDK.framework into your Xcode project.

### Manually

If you link the library manually, use a version from our [releases](https://github.com/tranzzo/tranzzo-ios/releases) page.

## Features

**Tokenization**: Simple way to obtain a Tranzzo user card token, generated on our servers.

## Usage

1. Import TranzzoSDK framework header

    ```swift
    import TranzzoSDK
    ```

2. Initialize the tokenizer for an environment you are working with
    
    ```swift
    let tokenizer = TranzzoTokenizer(apiToken: <#appToken#>, environment: <#environment#>)
    ```
    Make sure to replace `appToken` with your application token. Find it [here](https://tranzzo.com).
    
3. Construct a card data with your user's card information
    
    ```swift
    let card = CardRequestData(
        cardNumber: "4242424242424242",
        expirationDate: CardExpirationDate(month: 12, year: 22),
        cardCvv: "123"
    )
    ```
4. Send a request through a tokenizer to receive a token for your card 
    ```swift
    tokenizer.tokenize(card: card) { (result: Result<TokenSuccessResponse, TranzzoError>) in
        switch result {
        case .success(let tokenData):
            // Process your token
        case .failure(let error):
            // Handle an error
        }
    }
    ```

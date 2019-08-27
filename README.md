#  iOS SDK Tokenize Card (Light)

## Minimum system requirements
iOS: 9.0
Swift: 5.0

## Bundles
1. TranzzoSDKx86.framework (iphone simulator)
2. TranzzoSDKArm64.framework (64bit device)

## Install
Copy TranzzoSDK framework into your project and add to Embedded Binaries (in General tab) 



## Example usage

```swift
import UIKit
import TranzzoSDK
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiToken = "m03z1jKTSO6zUYQN5C8xYZnIclK0plIQ/3YMgTZbV6g7kxle6ZnCaHVNv3A11UCK"
        // Use `.prod` env for production api
        let trzApi = TranzzoTokenizeApi(apiToken: apiToken, env: .stage);
        let card = CardTokenRequest(cardNumber: "4242424242424242",
                                    cardExpMonth: 12,
                                    cardExpYear: 22,
                                    cardCvv: "123")
        
        
        
        trzApi.tokenize(card: card) { (result: Result<TokenSuccessResponse, TranzzoAPIError>) in
            switch result {
            case .success(let tokenData):
                print(tokenData)
            case .failure(let error):
                print(error)
            }
        }
    }
}

```


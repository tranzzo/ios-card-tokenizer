/*
 * Copyright (c) TRANZZO LTD - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

import Foundation

public struct TokenSuccessResponse: Codable {
    public let token: String
    public let expiresAt: String
    public let cardMask: String
}

class Constants {
    static let internalError = "Internal errror"
    static let genericErrorMessage = "Something went wrong, please try again."
}


public enum Environment: String {
    case prod
    case stage
    
    var baseURL: String {
        switch self {
        case .prod:
            return "https://widget.tranzzo.com"
        case .stage:
            return "https://widget-stg.tranzzo.com"
        }
    }
}


public struct TranzzoAPIError: Error {
    public var id: String?
    public var hint: String? = ""
    public var message: String?
    
    
    public init(id: String, hint: String) {
        self.id = id
        self.hint = hint
    }
    
    public init(message: String) {
        self.message = message
    }
}


struct TokenErrorResponse: Codable {
    let id: String
    let hint: String?
}

public class TranzzoTokenizeApi {
    let apiToken: String
    let env: Environment
    private let utils = CommonUtils()
    private let urlSession = URLSession.shared

    public init(apiToken: String, env: Environment) {
        self.apiToken = apiToken
        self.env = env
    }
    
    
    private func fetch<T>(card: CardTokenRequest,
                          completionHandler: @escaping (Result<T, TranzzoAPIError>) -> Void) where T: Codable {
        let baseUrl = env.baseURL
        let url = URL(string: "\(baseUrl)/api/v1/sdk/tokenize")!
        let serializeData: String = utils.stringBuilder(params: card)!
        let sign = serializeData.hmac(key: apiToken)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiToken, forHTTPHeaderField: "X-Widget-Id")
        request.setValue(sign, forHTTPHeaderField: "X-Sign")
        request.setValue("XmlHttpRequest", forHTTPHeaderField: "X-Requested-With")
        request.httpBody = try? utils.jsonEncoder.encode(card)
        
        urlSession.dataTask(with: request) { (result) in
            switch result {
            case .success(let (response, data)):
                do {
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        DispatchQueue.main.async {
                            completionHandler(.failure(self.parseApiError(data: data)!))
                        }
                        return
                    }
                    
                    let jsonResponse = try self.utils.jsonDecoder.decode(T.self, from: data)
                    
                    DispatchQueue.main.async {
                        completionHandler(.success(jsonResponse))
                    }
                    
                } catch let error {
                    let err = TranzzoAPIError(message: error.localizedDescription)
                    completionHandler(.failure(err))
                }
            case .failure(let error):
                completionHandler(.failure(TranzzoAPIError(message: error.localizedDescription)))
            }
        }.resume()
    }
    
    
    public func tokenize(card: CardTokenRequest,
                  result: @escaping (Result<TokenSuccessResponse, TranzzoAPIError>) -> Void) {
        fetch(card: card, completionHandler: result)
    }
    
    private func parseApiError(data: Data?) -> TranzzoAPIError? {
        if let jsonData = data, let error = try? self.utils.jsonDecoder.decode(TokenErrorResponse.self, from: jsonData) {
            return TranzzoAPIError(id: error.id, hint: error.hint ?? "")
        }
        return nil
    }
}

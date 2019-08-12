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

public struct TokenErrorResponse: Codable {
    public let id: String
    public let hint: String?
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


class TranzzoTokenizeApi {
    let apiToken: String
    let env: Environment
    private let utils = CommonUtils()
    private let urlSession = URLSession.shared
    
    enum APIError: Error {
        case TokenErrorResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }
    
    init(apiToken: String, env: Environment) {
        self.apiToken = apiToken
        self.env = env
    }
    
    
    private func fetch<T: Decodable>(card: CardTokenRequest,
                                     completionHandler: @escaping (Result<T, APIError>) -> Void) {
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
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.TokenErrorResponse))
                    }
                    return
                }
                do {
                    let jsonResponse = try self.utils.jsonDecoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(.success(jsonResponse))
                    }
                    
                } catch let error {
                    completionHandler(.failure(.jsonDecodingError(error: error)))
                }
            case .failure(let error):
                completionHandler(.failure(.networkError(error: error)))
            }
        }.resume()
        
        
    }
    
    public func tokenize(card: CardTokenRequest,
                  result: @escaping (Result<TokenSuccessResponse, APIError>) -> Void) {
        fetch(card: card, completionHandler: result)
    }
}

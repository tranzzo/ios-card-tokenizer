/*
 * Copyright (c) TRANZZO LTD - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

import Foundation

public struct TokenSuccessResponse: Codable {
    public let token: String
}

public struct TokenEncryptSuccessResponse: Codable {
    public let data: String
}

public class TranzzoTokenizer {
    // MARK: - Private Properties
    private let apiToken: String
    private let environment: Environment
    private let urlSession = URLSession.shared
    private let decoder = DataDecoder()
    private let encoder = DataEncoder()
    
    // MARK: - Init
    public init(apiToken: String, environment: Environment) {
        self.apiToken = apiToken
        self.environment = environment
    }
    
    // MARK: - Public Methods
    public func tokenize(card: CardRequestData,
                         result: @escaping (Result<TokenSuccessResponse, TranzzoError>) -> Void) {
        fetch(card: card, completionHandler: result)
    }
    
    public func tokenizeEncrypt(card: CardRequestData,
                                result: @escaping (Result<TokenEncryptSuccessResponse, TranzzoError>) -> Void) {
        fetch(card: card, completionHandler: result)
    }
    
    // MARK: - Private Methods
    private func fetch<T>(card: CardRequestData,
                          completionHandler: @escaping (Result<T, TranzzoError>) -> Void) where T: Codable {
        let sign = self.buildBodyString(params: card)?.hmac(key: apiToken)
        
        if var request = URLRequestBuilder.createURLRequest(to: environment.baseURL, requestData: .tokenize(card: card)) {
            request.setValue(sign, forHTTPHeaderField: "X-Sign")
            request.setValue(apiToken, forHTTPHeaderField: "X-Widget-Id")
            request.httpBody = try? encoder.encode(card)
            
            urlSession.dataTask(with: request) { (result) in
                switch result {
                case .success(let (response, data)):
                    guard
                        let statusCode = (response as? HTTPURLResponse)?.statusCode,
                        200..<299 ~= statusCode
                    else {
                        if let error = self.parseApiError(data: data) {
                            completionHandler(.failure(error))
                        }
                        return
                    }
                    do {
                        completionHandler(.success(try self.decoder.decode(T.self, from: data)))
                    } catch {
                        let error = TranzzoError(message: error.localizedDescription)
                        completionHandler(.failure(error))
                    }
                case .failure(let error):
                    completionHandler(.failure(TranzzoError(message: error.localizedDescription)))
                }
            }.resume()
        }
    }
    
    private func buildBodyString<T: Encodable>(params: T) -> String? {
        var dictionary: Any?
        do {
            let encodedData = try DataEncoder().encode(params)
            dictionary = try JSONSerialization.jsonObject(with: encodedData, options: .allowFragments)

        } catch {
            return nil
        }

        return (dictionary as? [String: Any])?
            .sorted { $0.key < $1.key }
            .map { (key, value) in
                if key == "rich" {
                    return "\(Bool(truncating: value as! NSNumber))"
                }
                return "\(value)" }
            .joined(separator: "")
    }
    
    private func parseApiError(data: Data?) -> TranzzoError? {
        if
            let jsonData = data,
            let error = try? self.decoder.decode(ErrorResponse.self, from: jsonData) {
            return TranzzoError(id: error.id, message: error.errorMessage, hint: error.hint ?? "")
        }
        return TranzzoError(message: Constants.genericErrorMessage)
    }
    
}

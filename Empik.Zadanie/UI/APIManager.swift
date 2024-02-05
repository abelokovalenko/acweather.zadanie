//
//  APIManager.swift
//  SharedAPIManager
//
//  Created by Aman on 04/08/23.
//

import UIKit
import Foundation

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

class CitiesSearchAPIManager {
    static let shared = CitiesSearchAPIManager()
    private let baseURL = "https://api.example.com"
    private init() {}
    
    func request<T: Codable>(endpoint: String, method: String, parameters: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void) {
        // Perform the API request with the provided endpoint, method, and parameters
        
        guard let url = URL(string: baseURL + endpoint) else {
                    completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                    return
                }
        // Assuming you're using URLSession to make the API request
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle the API response
            
            // Assuming you have a generic JSONDecoder to decode the API response
            let decoder = JSONDecoder()
            
            // Check if the token has expired
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                // Refresh the token
                self.refreshToken { result in
                    switch result {
                    case .success(let newToken):
                        // Retry the API request with the new token
                        self.retryRequest(endpoint: endpoint, method: method, parameters: parameters, token: newToken, completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else {
                // Decode the API response data
                if let data = data {
                    do {
                        let decodedResponse = try decoder.decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    private func refreshToken(completion: @escaping (Result<String, Error>) -> Void) {
        // Call the API to refresh the token
        let refreshTokenEndpoint = "https://api.example.com/refreshToken"
        
        guard let refreshToken = TokenManager.shared.refreshToken else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No refresh token available"])))
            return
        }
        
        let parameters = ["refreshToken": refreshToken]
        
        request(endpoint: refreshTokenEndpoint, method: "POST", parameters: parameters) { (result: Result<TokenResponse, Error>) in
            switch result {
            case .success(let tokenResponse):
                // Update the tokens
                TokenManager.shared.updateTokens(accessToken: tokenResponse.accessToken, refreshToken: tokenResponse.refreshToken)
                // Pass the new access token to the completion handler
                completion(.success(tokenResponse.accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func retryRequest<T: Codable>(endpoint: String, method: String, parameters: [String: Any]?, token: String, completion: @escaping (Result<T, Error>) -> Void) {
        // Update the token in the request headers or authentication mechanism
        
        // Example implementation:
        var updatedHeaders = ["Authorization": "Bearer \(token)"]
        // Add other required headers
        
        guard let url = URL(string: endpoint) else {
                    completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                    return
                }
        // Perform the API request with the updated token
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle the API response
            
            // Assuming you have a generic JSONDecoder to decode the API response
            let decoder = JSONDecoder()
            
            // Decode the API response data
            if let data = data {
                do {
                    let decodedResponse = try decoder.decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
// Token Manager
class TokenManager {
    static let shared = TokenManager()
    
    var refreshToken: String?
    var accessToken: String?
    
    private init() {}
    
    func updateTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func clearTokens() {
        accessToken = nil
        refreshToken = nil
    }
}

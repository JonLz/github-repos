//
//  Networking.swift
//  github-repos
//
//  Created by Jon on 9/10/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import PromiseKit

enum NetworkingError: Error, LocalizedError {
    case invalidParameters
    case invalidUrl
    case statusCodeError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidParameters: return "Invalid parameters"
        case .invalidUrl: return "Invalid url"
        case .statusCodeError(let code): return "Bad status code received: \(code)"
        }
    }
}

protocol Networking {
    func urlRequest(_ request: URLRequest) -> Promise<(data: Data, response: HTTPURLResponse)>
}

extension Networking {
    func request<TypedRequest: DecodedHTTPRequest>(_ httpRequest: TypedRequest) -> Promise<TypedRequest.DecodingType> {
        
        var urlComponents = URLComponents(string: "https://api.github.com")
        urlComponents?.path = httpRequest.path

        var httpBody: Data?
        
        switch httpRequest.httpMethod {
        case .get:
            urlComponents?.queryItems = httpRequest.params.compactMap { param in
                return URLQueryItem(name: param.key, value: param.value)
            }
            
        case .post:
            guard let jsonData = try? JSONSerialization.data(withJSONObject: httpRequest.params, options: .prettyPrinted) else {
                return Promise.init(error: NetworkingError.invalidParameters)
            }
            
            httpBody = jsonData
        }
        
        guard let url = urlComponents?.url else {
            return Promise(error: NetworkingError.invalidUrl)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpRequest.httpMethod.rawValue
        request.httpBody = httpBody
        
        return urlRequest(request)
            .then { result -> Promise<TypedRequest.DecodingType> in
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decoded = try decoder.decode(TypedRequest.DecodingType.self, from: result.data)
                    return Promise.value(decoded)
                } catch {
                    return Promise.init(error: error)
                }
            }
    }
}

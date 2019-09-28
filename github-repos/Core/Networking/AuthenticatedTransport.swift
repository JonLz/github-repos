//
//  AuthenticatedTransport.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import PromiseKit

/*
 
 A transport to make authenticated API requests
 
 */
class AuthenticatedTransport: Networking {
    let session: URLSession = .init(configuration: .ephemeral)
    let tokenStore: TokenStore
    
    init(tokenStore: TokenStore) {
        self.tokenStore = tokenStore
    }
    
    func urlRequest(_ request: URLRequest) -> Promise<(data: Data, response: HTTPURLResponse)> {
        var req = request
        req.addValue("Basic \(tokenStore.token)", forHTTPHeaderField: "Authorization")
        
        return session.urlRequest(req)
            .then { result -> Promise<(data: Data, response: HTTPURLResponse)> in
                guard (200...299).contains(result.response.statusCode) else {
                    return Promise(error: NetworkingError.statusCodeError(result.response.statusCode))
                }
                
                return Promise.value(result)
            }
    }
}

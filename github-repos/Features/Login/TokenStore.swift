//
//  TokenStore.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import PromiseKit

enum TokenStoreError: LocalizedError {
    case encodingError
    
    var errorDescription: String? {
        switch self {
        case .encodingError: return "Error creating authentication token. Encoding error."
        }
    }
}

/*
 
 Handles validation and encoding of credentials for basic authentication via the GitHub API
 
 */
class TokenStore: Codable {
    let token: String
    
    init(username: String, password: String) throws {
        let input = "\(username):\(password)"
        let data = input.data(using: .utf8)
        if let token = data?.base64EncodedString() {
            self.token = token
        } else {
            throw TokenStoreError.encodingError
        }
    }
    
    static func createTokenStore(username: String, password: String) -> Promise<TokenStore> {
        do {
            let tokenStore = try TokenStore(username: username, password: password)
            return Promise.value(tokenStore)
        } catch {
            return Promise(error: error)
        }
    }
    
    func validate() -> Promise<TokenStore> {
        let transport = AuthenticatedTransport(tokenStore: self)
        return transport.request(UserRequest()).then { _ in return Promise.value(self) }
    }
}

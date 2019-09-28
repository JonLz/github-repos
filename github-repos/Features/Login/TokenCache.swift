//
//  TokenCache.swift
//  github-repos
//
//  Created by Jon on 9/13/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Foundation

/*
 
 Handles storage and retrieval for a TokenStore object
 
 */
class TokenCache {
    
    private let tokenCacheKey = "com.github-repos.token-cache-key"
    
    func delete() {
        UserDefaults.standard.removeObject(forKey: tokenCacheKey)
    }
    
    func get() -> TokenStore? {
        guard
            let cachedStoreData = UserDefaults.standard.value(forKey: tokenCacheKey) as? Data,
            let cachedStore = try? JSONDecoder().decode(TokenStore.self, from: cachedStoreData) else {
                return nil
        }
        
        return cachedStore
    }
    
    func set(tokenStore: TokenStore) {
        guard let cachableStore = try? JSONEncoder().encode(tokenStore) else {
            return
        }
        
        UserDefaults.standard.set(cachableStore, forKey: tokenCacheKey)
    }
}

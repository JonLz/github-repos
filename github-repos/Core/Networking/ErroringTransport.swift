//
//  ErroringTransport.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import PromiseKit

/*
 
 A transport for debugging error states.
 Returns 404 errors for all requests.
 
 */
class ErroringTransport: Networking {
    let session: URLSession = .init(configuration: .ephemeral)
    
    func urlRequest(_ request: URLRequest) -> Promise<(data: Data, response: HTTPURLResponse)> {
        #if !DEBUG
        fatalError()
        #endif
        
        return session.urlRequest(request)
            .then { result -> Promise<(data: Data, response: HTTPURLResponse)> in
               return Promise(error: NetworkingError.statusCodeError(404))
            }
    }
}

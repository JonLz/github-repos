//
//  URLSession+Networking.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import PromiseKit

extension URLSession: Networking {
    func urlRequest(_ request: URLRequest) -> Promise<(data: Data, response: HTTPURLResponse)> {
        return self.dataTask(.promise, with: request)
            .compactMap({ data,response in
                if let httpResponse = response as? HTTPURLResponse {
                    return (data,httpResponse)
                }
                return nil
            })
    }
}

//
//  UserRequest.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Foundation

struct UserRequest: DecodedHTTPRequest {
    typealias DecodingType = DiscardableApiResult
    
    let httpMethod: HTTPMethod = .get
    let path: String = "/user"
    let params: [String : String] = [:]
}

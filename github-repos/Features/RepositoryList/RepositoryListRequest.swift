//
//  RepositoryListRequest.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Foundation

enum RepositoryType: String {
    case all
    case owner
    case `public`
    case `private`
    case member
}

class RepositoryListRequest: DecodedHTTPRequest {
    typealias DecodingType = [Repository]
    
    let httpMethod: HTTPMethod = .get
    let path: String = "/user/repos"
    let params: [String : String]
    
    init(_ repositoryType: RepositoryType) {
        params = [
            "type" : repositoryType.rawValue,
            "per_page" : "100"
        ]
    }
    
}

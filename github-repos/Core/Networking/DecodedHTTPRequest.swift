//
//  DecodedHTTPRequest.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol DecodedHTTPRequest {
    associatedtype DecodingType: Decodable
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var params: [String : String] { get }
}

struct DiscardableApiResult: Decodable {}

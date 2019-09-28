//
//  PullRequestsRequest.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Foundation

enum PullRequestState: String {
    case all
    case closed
    case open
}

struct PullRequestsRequest: DecodedHTTPRequest {
    typealias DecodingType = [GithubHistoricalItem]
    
    let httpMethod: HTTPMethod = .get
    let path: String
    let params: [String : String]
    
    init(fullName: String, pullRequestState: PullRequestState) {
        let path = "/repos/\(fullName)/pulls"
        
        guard let oneYearAgo = Date().oneYearAgo else {
            fatalError("Could not construct date from a year ago for request: \(path)")
        }
        
        self.path = path
        self.params = [
            "state" : pullRequestState.rawValue,
            "since" : DateFormatter.iso8601Formatter.string(from: oneYearAgo),
            "per_page" : "100"
        ]
    }
}

//
//  GithubHistoricalItem.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Foundation

struct GithubHistoricalItem: Decodable {
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
    }
}

//
//  Repository.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    let id: Int64
    let name: String
    let description: String?
    let full_name: String
}

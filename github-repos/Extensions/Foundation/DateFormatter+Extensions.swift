//
//  DateFormatter+Extensions.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let iso8601Formatter: ISO8601DateFormatter = ISO8601DateFormatter()
    static let short: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        return dateFormatter
    }()
}

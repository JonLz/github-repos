//
//  Date+Extensions.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Foundation

extension Date {
    var nextMonday: Date? {
        let calendar = Calendar.current
        let monday = DateComponents(calendar: calendar,
                                    weekday: 2)
        return calendar.nextDate(after: self,
                                 matching: monday,
                                 matchingPolicy: .nextTime)
    }
    
    var oneYearAgo: Date? {
        return Calendar.current.date(byAdding: .year, value: -1, to: Date())
    }
}

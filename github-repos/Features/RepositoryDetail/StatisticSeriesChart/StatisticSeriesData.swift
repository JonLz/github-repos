//
//  StatisticSeriesData.swift
//  github-repos
//
//  Created by Jon on 9/12/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import SwiftChart

private struct TimeSeriesDataPoint {
    /// The x-axis point this data point maps to
    let offset: Int
    
    /// The number of data points for this date (y-axis value)
    let count: Int
    
    /// The date bucket to aggregate data points by
    let date: Date
}

struct StatisticSeriesData {
    let series: ChartSeries
    let title: String
    let legendTitle: String
    private let timeSeriesData: [TimeSeriesDataPoint]
    
    init(title: String, legendTitle: String, githubItems: [GithubHistoricalItem]) {
        self.title = title
        self.legendTitle = legendTitle
        
        guard let oneYearAgo = Date().oneYearAgo else {
            fatalError("Could not construct a date one year ago from today: \(Date())")
        }
   
        // A dictionary to track a weekly count of historical items
        // - key: Monday of the prior year through today
        // - value: count of weekly items matched from the previous Tuesday
        var buckets = [Date : Int]()
        var bucketKey: Date? = oneYearAgo
        
        while let key = bucketKey, key <= Date(), buckets.keys.count <= 52 {
            buckets[key] = 0
            bucketKey = bucketKey?.nextMonday
        }
        
        githubItems.forEach { item in
            let dateKey = item.updatedAt.nextMonday ?? item.updatedAt
            buckets[dateKey, default: 0] += 1
        }
        
        timeSeriesData = buckets.keys
            .sorted { $0 < $1 }
            .enumerated()
            .map { enumeratedDate -> TimeSeriesDataPoint in
                return TimeSeriesDataPoint(offset: enumeratedDate.offset,
                                           count: buckets[enumeratedDate.element]!,
                                           date: enumeratedDate.element)
            }
        
        let chartData = timeSeriesData.map { return (Double($0.offset), Double($0.count)) }
        self.series = ChartSeries(data: chartData)
        series.area = true
    }
    
    func date(for offset: Int) -> Date? {
        guard offset < timeSeriesData.count, offset > 0 else {
            return nil
        }
        return timeSeriesData[offset].date
    }
    
    func count(for offset: Int) -> Int? {
        guard offset < timeSeriesData.count, offset > 0 else {
            return nil
        }
        return timeSeriesData[offset].count
    }
}

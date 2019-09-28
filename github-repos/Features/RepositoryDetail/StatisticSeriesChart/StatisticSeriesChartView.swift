//
//  StatisticSeriesChart.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Anchorage
import SwiftChart

class StatisticSeriesChartView: UIView, ChartDelegate {
    
    private var chartRawData: StatisticSeriesData?
    
    private lazy var chartView: Chart = {
        let chart = Chart(frame: .zero)
        chart.showYLabelsAndGrid = false
        chart.showXLabelsAndGrid = false
        chart.delegate = self
        return chart
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = Layout.Component.Label.makeBoldTitle()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = Layout.Component.Label.makeBoldTitle()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = Layout.Component.Label.makeBoldTitle()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var legendStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(chartView)
        addSubview(titleLabel)
        addSubview(legendStackView)
        legendStackView.addArrangedSubview(dateLabel)
        legendStackView.addArrangedSubview(countLabel)
        
        titleLabel.topAnchor == topAnchor + 10
        titleLabel.horizontalAnchors == horizontalAnchors
        
        chartView.topAnchor == titleLabel.bottomAnchor + 10
        chartView.horizontalAnchors == horizontalAnchors
        chartView.heightAnchor == 180
        
        legendStackView.topAnchor == chartView.bottomAnchor + 10
        legendStackView.horizontalAnchors == horizontalAnchors
        legendStackView.bottomAnchor == bottomAnchor - 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(data: StatisticSeriesData) {
        chartView.removeAllSeries()
        chartView.add(data.series)
        titleLabel.text = data.title
        chartRawData = data
        dateLabel.text = ""
        countLabel.text = ""
    }
}

// MARK: - ChartDelegate

extension StatisticSeriesChartView {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        guard
            let title = chartRawData?.legendTitle,
            let firstIndex = indexes.first,
            let offset = firstIndex,
            let chartRawData = chartRawData,
            let date = chartRawData.date(for: offset),
            let count = chartRawData.count(for: offset)
        else {
            return
        }
        
        let dateFormatter = DateFormatter.short
        dateLabel.text = "Date: \(dateFormatter.string(from: date))"
        countLabel.text = "\(title): \(count)"
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        dateLabel.text = ""
        countLabel.text = ""
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        // no-op
    }
}

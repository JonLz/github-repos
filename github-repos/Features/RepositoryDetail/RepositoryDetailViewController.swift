//
//  RepositoryDetailViewController.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Anchorage
import PromiseKit
import UIKit

class RepositoryDetailViewController: UIViewController {
    
    private let transport: Networking
    private let repository: Repository
    
    private lazy var openIssuesView: RepositoryDetailStatisticComponentView = {
        let view = RepositoryDetailStatisticComponentView()
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(handleOpenIssuesTap))
        view.addGestureRecognizer(gestureRecognizer)
        return view
    }()
    
    private lazy var openIssuesViewModel: RepositoryDetailStatisticComponentViewModel<IssuesRequest> = {
        let request = IssuesRequest(fullName: repository.full_name,
                                    issueState: .open)
        
        let builder: ([GithubHistoricalItem]) -> RepositoryDetailStatistic = {
            return RepositoryDetailStatistic(title: "Open Issues",
                                             count: $0.count)
        }
        
        return RepositoryDetailStatisticComponentViewModel(transport: transport,
                                                           request: request,
                                                           builder: builder,
                                                           view: openIssuesView)
    }()
    
    private lazy var closedIssuesView: RepositoryDetailStatisticComponentView = {
        let view = RepositoryDetailStatisticComponentView()
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(handleClosedIssuesTap))
        view.addGestureRecognizer(gestureRecognizer)
        return view
    }()
    
    private lazy var closedIssuesViewModel: RepositoryDetailStatisticComponentViewModel<IssuesRequest> = {
        let request = IssuesRequest(fullName: repository.full_name,
                                    issueState: .closed)
        
        let builder: ([GithubHistoricalItem]) -> RepositoryDetailStatistic = {
            return RepositoryDetailStatistic(title: "Closed Issues",
                                             count: $0.count)
        }
        
        return RepositoryDetailStatisticComponentViewModel(transport: transport,
                                                           request: request,
                                                           builder: builder,
                                                           view: closedIssuesView)
    }()
        
    private lazy var openPullRequestsView: RepositoryDetailStatisticComponentView = {
        let view = RepositoryDetailStatisticComponentView()
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(handleOpenPRsTap))
        view.addGestureRecognizer(gestureRecognizer)
        return view
    }()
    
    private lazy var openPullRequestsViewModel: RepositoryDetailStatisticComponentViewModel<PullRequestsRequest> = {
        let request = PullRequestsRequest(fullName: repository.full_name,
                                          pullRequestState: .open)
        
        let builder: ([GithubHistoricalItem]) -> RepositoryDetailStatistic = {
            return RepositoryDetailStatistic(title: "Open PRs",
                                             count: $0.count)
        }
        
        return RepositoryDetailStatisticComponentViewModel(transport: transport,
                                                           request: request,
                                                           builder: builder,
                                                           view: openPullRequestsView)
    }()
        
    private lazy var closedPullRequestsView: RepositoryDetailStatisticComponentView = {
        let view = RepositoryDetailStatisticComponentView()
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(handleClosedPRsTap))
        view.addGestureRecognizer(gestureRecognizer)
        return view
    }()
    
    private lazy var closedPullRequestsViewModel: RepositoryDetailStatisticComponentViewModel<PullRequestsRequest> = {
        let request = PullRequestsRequest(fullName: repository.full_name,
                                          pullRequestState: .closed)
        
        let builder: ([GithubHistoricalItem]) -> RepositoryDetailStatistic = {
            return RepositoryDetailStatistic(title: "Closed PRs",
                                             count: $0.count)
        }
        
        return RepositoryDetailStatisticComponentViewModel(transport: transport,
                                                           request: request,
                                                           builder: builder,
                                                           view: closedPullRequestsView)
    }()
    
    private lazy var issuesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var pullRequestsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let chartView = StatisticSeriesChartView()
    
    init(transport: Networking, repository: Repository) {
        self.transport = transport
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
        
        title = repository.name
        
        view.addSubview(issuesStackView)
        issuesStackView.addArrangedSubview(openIssuesView)
        issuesStackView.addArrangedSubview(closedIssuesView)
        
        view.addSubview(pullRequestsStackView)
        pullRequestsStackView.addArrangedSubview(openPullRequestsView)
        pullRequestsStackView.addArrangedSubview(closedPullRequestsView)
        
        view.addSubview(chartView)
        
        issuesStackView.topAnchor == verticalAnchors.first + Layout.Constant.Screen.verticalMargins
        issuesStackView.horizontalAnchors == horizontalAnchors + Layout.Constant.Screen.horizontalMargins
        
        pullRequestsStackView.topAnchor == issuesStackView.bottomAnchor + Layout.Constant.Screen.verticalMargins
        pullRequestsStackView.horizontalAnchors == horizontalAnchors + Layout.Constant.Screen.horizontalMargins
        
        chartView.topAnchor == pullRequestsStackView.bottomAnchor + 40
        chartView.horizontalAnchors == horizontalAnchors + Layout.Constant.Screen.horizontalMargins
        
        chartView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        openIssuesViewModel.load()
        closedIssuesViewModel.load()
        openPullRequestsViewModel.load()
        closedPullRequestsViewModel.load()
    }
    
    @objc func handleOpenIssuesTap() {
        guard let data = openIssuesViewModel.data else {
            return
        }
        
        chartView.isHidden = false
        let chartData = StatisticSeriesData(title: "Open Issues Over Time",
                                            legendTitle: "Open issues",
                                            githubItems: data)
        chartView.set(data: chartData)
        setSelected(openIssuesView)
    }
    
    @objc func handleClosedIssuesTap() {
        guard let data = closedIssuesViewModel.data else {
            return
        }
        
        chartView.isHidden = false
        let chartData = StatisticSeriesData(title: "Closed Issues Over Time",
                                            legendTitle: "Closed issues",
                                            githubItems: data)
        chartView.set(data: chartData)
        setSelected(closedIssuesView)
    }
    
    @objc func handleOpenPRsTap() {
        guard let data = openPullRequestsViewModel.data else {
            return
        }
     
        chartView.isHidden = false
        let chartData = StatisticSeriesData(title: "Open PRs Over Time",
                                            legendTitle: "Open PRs",
                                            githubItems: data)
        chartView.set(data: chartData)
        setSelected(openPullRequestsView)
        
    }
    
    @objc func handleClosedPRsTap() {
        guard let data = closedPullRequestsViewModel.data else {
            return
        }
        
        chartView.isHidden = false
        let chartData = StatisticSeriesData(title: "Closed PRs Over Time",
                                            legendTitle: "Closed PRs",
                                            githubItems: data)
        chartView.set(data: chartData)
        setSelected(closedPullRequestsView)
    }
    
    private func setSelected(_ component: RepositoryDetailStatisticComponentView) {
        [openIssuesView, closedIssuesView, openPullRequestsView, closedPullRequestsView].forEach { component in
            component.isSelected = false
        }
        component.isSelected = true
    }
}

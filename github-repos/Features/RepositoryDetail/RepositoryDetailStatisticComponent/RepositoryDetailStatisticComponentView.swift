//
//  RepositoryDetailStatisticComponentView.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Anchorage
import UIKit

enum RepositoryDetailStatisticComponentViewState {
    case loading
    case loaded(RepositoryDetailStatistic)
    case error(Error)
}

class RepositoryDetailStatisticComponentView: UIView {
    
    var isSelected: Bool = false {
        didSet {
            layer.borderColor = isSelected ? selectedBorderColor : unselectedBorderColor
        }
    }
    
    private lazy var countLabel: UILabel = {
        return Layout.Component.Label.makeBoldStatistic()
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = Layout.Component.Label.makeBoldTitle()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = Layout.Component.Label.makeTitle()
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let unselectedBorderColor = Layout.Color.grey.cgColor
    private let selectedBorderColor = UIColor.blue.withAlphaComponent(0.8).cgColor
    
    init() {
        super.init(frame: .zero)
        
        layer.borderWidth = 3
        layer.borderColor = unselectedBorderColor
        backgroundColor = Layout.Color.grey.withAlphaComponent(0.6)
        
        addSubview(countLabel)
        addSubview(titleLabel)
        addSubview(errorLabel)
        addSubview(spinner)
        
        countLabel.topAnchor == topAnchor + 10
        countLabel.horizontalAnchors == horizontalAnchors + 10
        
        titleLabel.topAnchor == countLabel.bottomAnchor + 5
        titleLabel.horizontalAnchors == horizontalAnchors + 10
        titleLabel.bottomAnchor == bottomAnchor - 10
        
        spinner.centerAnchors == centerAnchors
        errorLabel.edgeAnchors == edgeAnchors + 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewState: RepositoryDetailStatisticComponentViewState) {
        switch viewState {
        case .loading:
            countLabel.isHidden = true
            titleLabel.isHidden = true
            errorLabel.isHidden = true
            spinner.startAnimating()
            
        case .loaded(let statistic):
            countLabel.isHidden = false
            titleLabel.isHidden = false
            errorLabel.isHidden = true
            spinner.stopAnimating()
            
            countLabel.text = "\(statistic.count)"
            titleLabel.text = statistic.title
            
        case .error(let error):
            countLabel.isHidden = true
            titleLabel.isHidden = true
            errorLabel.isHidden = false
            spinner.stopAnimating()
            
            errorLabel.text = error.localizedDescription
        }
    }
}

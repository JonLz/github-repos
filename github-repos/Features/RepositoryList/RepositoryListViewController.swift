//
//  RepositoryListViewController.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Anchorage
import PromiseKit
import UIKit

enum RepositoryListTapEvent {
    case repository(Repository)
}

protocol RepositoryListTapEventProvider {
    func tapEvent(indexPath: IndexPath) -> RepositoryListTapEvent?
}

extension RepositoryListTapEventProvider {
    func tapEvent(indexPath: IndexPath) -> RepositoryListTapEvent? {
        return nil
    }
}

protocol RepositoryListDelegate: class {
    func didSelectLogout()
    func didSelectRepository(_ repository: Repository)
}

class RepositoryListViewController: UIViewController, UITableViewDelegate {
    
    weak var delegate: RepositoryListDelegate?
    
    private let transport: Networking
    private var dataSource: UITableViewDataSource & RepositoryListTapEventProvider = RepositoryListViewDataSource() {
        didSet {
            tableView.dataSource = dataSource
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(RepositoryListTableViewCell.self, forCellReuseIdentifier: RepositoryListTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    init(transport: Networking) {
        self.transport = transport
        super.init(nibName: nil, bundle: nil)
        
        title = "Public repositories"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleLeftBarButtonItemTapped))
        view.addSubview(tableView)
        tableView.edgeAnchors == view.edgeAnchors
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = RepositoryListViewLoadingDataSource()
        firstly {
            transport.request(RepositoryListRequest(.public))
        }.done { repositories in
            self.dataSource = RepositoryListViewDataSource(repositories: repositories)
        }.catch { error in
            self.dataSource = RepositoryListViewErrorDataSource(error: error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    @objc func handleLeftBarButtonItemTapped() {
        delegate?.didSelectLogout()
    }
}
    
// MARK: - UITableViewDelegate

extension RepositoryListViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tapEvent = dataSource.tapEvent(indexPath: indexPath) {
            switch tapEvent {
            case .repository(let repository):
                delegate?.didSelectRepository(repository)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return dataSource.tapEvent(indexPath: indexPath) != nil
    }
}

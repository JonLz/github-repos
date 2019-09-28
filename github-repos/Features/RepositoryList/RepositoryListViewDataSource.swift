//
//  RepositoryListDataSource.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import UIKit

class RepositoryListViewDataSource: NSObject, UITableViewDataSource, RepositoryListTapEventProvider {
    
    private let repositories: [Repository]
    
    init(repositories: [Repository] = []) {
        self.repositories = repositories
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryListTableViewCell.reuseIdentifier) as! RepositoryListTableViewCell
        let repository = repositories[indexPath.row]
        cell.configure(repository: repository)
        return cell
    }
    
    func tapEvent(indexPath: IndexPath) -> RepositoryListTapEvent? {
        return .repository(repositories[indexPath.row])
    }
}

class RepositoryListViewErrorDataSource: NSObject, UITableViewDataSource, RepositoryListTapEventProvider {
    
    private let error: Error
    
    init(error: Error) {
        self.error = error
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryListTableViewCell.reuseIdentifier) as! RepositoryListTableViewCell
        cell.configure(error: error)
        return cell
    }
}

class RepositoryListViewLoadingDataSource: NSObject, UITableViewDataSource, RepositoryListTapEventProvider {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryListTableViewCell.reuseIdentifier) as! RepositoryListTableViewCell
        cell.configureLoading()
        return cell
    }
}

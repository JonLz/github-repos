//
//  RepositoryListTableViewCell.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import UIKit

class RepositoryListTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: self)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = ""
        detailTextLabel?.text = ""
        accessoryType = .none
    }
    
    func configure(repository: Repository) {
        textLabel?.text = repository.name
        detailTextLabel?.text = repository.description
        accessoryType = .disclosureIndicator
    }
    
    func configure(error: Error) {
        textLabel?.text = "Repositories Error"
        detailTextLabel?.text = error.localizedDescription
    }
    
    func configureLoading() {
        textLabel?.text = "Loading..."
        detailTextLabel?.text = "Fetching repositories from Github."
    }
}

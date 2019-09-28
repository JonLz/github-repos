//
//  LoggedInController.swift
//  github-repos
//
//  Created by Jon on 9/13/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import UIKit

/*
 
 Handles features for users after they log in
 
 */
class LoggedInController: RepositoryListDelegate {
    
    private let tokenStore: TokenStore
    private let presentingViewController: UIViewController
    private let rootNavigationController = UINavigationController()
    private let applicationContext: ApplicationContext
    
    private lazy var authenticatedTransport: AuthenticatedTransport = {
       return AuthenticatedTransport(tokenStore: tokenStore)
    }()
    
    init(tokenStore: TokenStore, presentingViewController: UIViewController, applicationContext: ApplicationContext) {
        self.tokenStore = tokenStore
        self.presentingViewController = presentingViewController
        self.applicationContext = applicationContext
    }
    
    func start(animated: Bool) {
        let repositoryListViewController = RepositoryListViewController(transport: authenticatedTransport)
        repositoryListViewController.delegate = self
        rootNavigationController.setViewControllers([repositoryListViewController], animated: false)
        presentingViewController.present(rootNavigationController, animated: animated)
    }
}

// MARK: - RepositoryListDelegate

extension LoggedInController {
    func didSelectLogout() {
        applicationContext.applicationInteractor.logout()
    }
    
    func didSelectRepository(_ repository: Repository) {
        let repositoryDetailViewController = RepositoryDetailViewController(transport: authenticatedTransport, repository: repository)
        rootNavigationController.pushViewController(repositoryDetailViewController, animated: true)
    }
}

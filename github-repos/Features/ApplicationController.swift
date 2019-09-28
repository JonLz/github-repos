//
//  ApplicationController.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import UIKit

/// Invocable methods for child contexts
protocol ApplicationInteractable {
    func logout()
}

/// Dependency injection container for exposing root level protocols to child contexts
protocol ApplicationContext: class {
    var applicationInteractor: ApplicationInteractable { get }
}

/*
 
 Handles application setup and view controller startup business logic
 
 */
class ApplicationController: GithubLoginDelegate, ApplicationInteractable {
    
    private let rootViewController = GithubLoginViewController()
    private let tokenCache = TokenCache()
    private var loggedInController: LoggedInController?
    
    init(window: UIWindow?) {
        rootViewController.delegate = self
        window?.rootViewController = rootViewController
    }
    
    private func makeLoggedInController(tokenStore: TokenStore?) -> LoggedInController? {
        guard let tokenStore = tokenStore else {
            return nil
        }
       
        return LoggedInController(tokenStore: tokenStore,
                                  presentingViewController: rootViewController,
                                  applicationContext: makeApplicationContext())
    }
    
    private func makeApplicationContext() -> ApplicationContext {
        class AppContainer: ApplicationContext {
            let applicationInteractor: ApplicationInteractable
            
            init(applicationInteractor: ApplicationInteractable) {
                self.applicationInteractor = applicationInteractor
            }
        }
        
        return AppContainer(applicationInteractor: self)
    }
}

// MARK: - GithubLoginDelegate

extension ApplicationController {
    func didAppear() {
        loggedInController = makeLoggedInController(tokenStore: tokenCache.get())
        loggedInController?.start(animated: false)
    }
    
    func didLogin(tokenStore: TokenStore) {
        let loggedInController = makeLoggedInController(tokenStore: tokenStore)
        loggedInController?.start(animated: true)
        self.loggedInController = loggedInController
        
        tokenCache.set(tokenStore: tokenStore)
    }
}

// MARK: - ApplicationInteractable

extension ApplicationController {
    func logout() {
        tokenCache.delete()
        loggedInController = nil
        rootViewController.dismiss(animated: true, completion: nil)
    }
}

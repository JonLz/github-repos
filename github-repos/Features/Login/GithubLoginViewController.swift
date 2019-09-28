//
//  ViewController.swift
//  github-repos
//
//  Created by Jon on 9/10/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Anchorage
import PromiseKit

protocol GithubLoginDelegate: class {
    func didLogin(tokenStore: TokenStore)
    func didAppear()
}

/*
 
 Screen to allow a user to login to Github with a username and password
 
 */
class GithubLoginViewController: UIViewController {
    
    weak var delegate: GithubLoginDelegate?
    
    private lazy var loginCtaLabel: UILabel = {
        let label = Layout.Component.Label.makeBoldTitle()
        label.textAlignment = .center
        label.text = "Sign in to GitHub"
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        return Layout.Component.TextField.makeUsernameEntry()
    }()
    
    private lazy var passwordTextField: UITextField = {
        return Layout.Component.TextField.makePasswordEntry()
    }()
    
    private lazy var loginButton: UIButton = {
        let button = Layout.Component.Button.makePrimaryButton(title: "Sign in")
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        return stackView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(loginCtaLabel)
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        
        stackView.centerAnchors == view.centerAnchors
        stackView.horizontalAnchors == view.horizontalAnchors + Layout.Constant.Screen.horizontalMargins
        
        stackView.arrangedSubviews.forEach { $0.heightAnchor >= 40 }
        
        usernameTextField.text = ""
        passwordTextField.text = ""
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.didAppear()
    }
    
    @objc func handleLogin() {
        firstly {
            TokenStore.createTokenStore(username: usernameTextField.text ?? "",
                                        password: passwordTextField.text ?? "")
        }.then { tokenStore -> Promise<TokenStore> in
            tokenStore.validate()
        }.done { tokenStore in
            self.delegate?.didLogin(tokenStore: tokenStore)
        }.catch { error in
            let title: String = "Login Error"
            var message: String = "Sorry, we were not able to complete this request at this time."
            message += "\n\nHere's what we know:\n\n\(error.localizedDescription)"
            
            let alertController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok",
                                         style: .default,
                                         handler: nil)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func handleBackgroundTapped() {
        [usernameTextField, passwordTextField].forEach { $0.resignFirstResponder() }
    }
}

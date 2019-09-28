//
//  RepositoryDetailStatisticComponentViewModel.swift
//  github-repos
//
//  Created by Jon on 9/11/19.
//  Copyright © 2019 Jon Lazar. All rights reserved.
//

import Foundation
import PromiseKit

class RepositoryDetailStatisticComponentViewModel<T: DecodedHTTPRequest> {
    
    private(set) var data: T.DecodingType?
    private let transport: Networking
    private let request: T
    private let builder: (T.DecodingType) -> RepositoryDetailStatistic
    private weak var view: RepositoryDetailStatisticComponentView?
    
    init(transport: Networking,
         request: T,
         builder: @escaping ((T.DecodingType) -> RepositoryDetailStatistic),
         view: RepositoryDetailStatisticComponentView) {
        self.transport = transport
        self.request = request
        self.builder = builder
        self.view = view
    }
    
    func load() {
        view?.configure(viewState: .loading)
       
        firstly {
            transport.request(request)
        }.done { response in
            self.data = response
            let statistic = self.builder(response)
            self.view?.configure(viewState: .loaded(statistic))
        }.catch { error in
            self.view?.configure(viewState: .error(error))
        }
    }
}

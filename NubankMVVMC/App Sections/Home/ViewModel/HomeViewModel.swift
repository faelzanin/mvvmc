//
//  HomeViewModel.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import UIKit

class HomeViewModel {
    
    // MARK: Variables
    var model: HomeModel?
    var homeObservable: Observable<RequestStates<HomeModel>>
    weak var delegate: HomeViewModelDelegate?
    
    // MARK: Init's
    init(with model: HomeModel) {
        self.model = model
        self.homeObservable = Observable(.empty)
    }
    
    // MARK: Functions
    func loadJoke(env: API.Environment? = nil) {
        homeObservable.value = .loading
        API(withEnviroment: env).homeServices.getRandomJoke(success: { [weak self] (joke) in
            guard let viewModel = self else { return }
            viewModel.model?.joke = joke
            viewModel.homeObservable.value = .load(data: viewModel.model!)
        }, failure: { [weak self] (error) in
            self?.homeObservable.value = .errored(error: error)
        })
    }
}

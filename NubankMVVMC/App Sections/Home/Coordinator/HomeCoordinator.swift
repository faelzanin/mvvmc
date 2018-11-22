//
//  HomeCoordinator.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import UIKit

class HomeCoordinator {
    
    // MARK: Variables
    var window: UIWindow
    var model: HomeModel?
    var viewModel: HomeViewModel?
    var viewController: HomeViewController?
    var navigationController: NavigationViewController?

    // MARK: Init's
    required init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        model                   = HomeModel()
        viewModel               = HomeViewModel(with: model!)
        viewModel?.delegate     = self
        viewController          = HomeViewController(viewModel: viewModel!)
        viewController?.hidesBottomBarWhenPushed  = true
        navigationController        = NavigationViewController(rootViewController: viewController!)
        navigationController?.defaultTransparentStyle()
        navigationController?.statusBarStyle = .lightContent
        window.rootViewController   = navigationController
    }
    
    func stop() {
        model           = nil
        viewModel       = nil
        viewController  = nil
    }
}

extension HomeCoordinator: HomeViewModelDelegate {
    /// Simply illustrating delegate usage
    func openAnotherScreen() {
        // Call other coordinator to start new flow.
    }
}

//
//  AppCoordinator.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: Variables
    var window: UIWindow
    var homeCoordinator: HomeCoordinator?
    
    // MARK: Init's
    required init(window: UIWindow) {
        self.window = window
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        homeCoordinator = HomeCoordinator(window: self.window)
        homeCoordinator?.start()
    }
}

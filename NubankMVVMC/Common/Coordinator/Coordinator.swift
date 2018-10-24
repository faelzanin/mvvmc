//
//  Coordinator.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var window: UIWindow { get set }
    init(window: UIWindow)
    func start()
}

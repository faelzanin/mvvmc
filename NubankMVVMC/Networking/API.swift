//
//  API.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import Foundation

class API {
    
    // MARK: Enums
    enum Environment: String {
        case production       =  "https://api.chucknorris.io"

        func getValue() -> String {
            return self.rawValue
        }
    }

    // MARK: Variables
    let environment: Environment
    
    // MARK: Init's
    init(withEnviroment env: Environment? = nil) {
        if let envi = env {
            environment = envi
        } else {
            environment = EnvConfig.baseURL
        }
    }
    
    // MARK: Lazy var of services.
    lazy var homeServices            = HomeRequests(withEnvironment: environment)

}

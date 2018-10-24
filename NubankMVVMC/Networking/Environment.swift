//
//  Environment.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import Foundation

struct EnvConfig {
    #if DEVELOPMENT
    static let baseURL: API.Environment = .mock
    #else
    static let baseURL: API.Environment = .production
    #endif
}

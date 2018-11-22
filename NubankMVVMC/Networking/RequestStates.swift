//
//  RequestStates.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import Foundation

enum RequestStates<T> {
    case loading
    case errored(error: ErrorHandler.ErrorResponse)
    case load(data: T)
    case empty
}

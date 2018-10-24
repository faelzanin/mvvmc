//
//  ErrorHandler.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import Foundation

/// Error list that deal with most of request errors
struct ErrorHandler: Codable {
    enum Error: Int, Codable {
        //-- Generic
        case withoutInternet                    = -1009
        case connectionLost                     = -1005
        case hostConnection                     = -1004
        case findHost                           = -1003
        case timeout                            = -1001
        case unknown                            = -1
        case parseError                         = -2
    }

    /// Response Error model
    struct ErrorResponse: Codable {
        var errors: [ErrorMessage]
    }

    /// Error Message
    struct ErrorMessage: Codable {
        var errorType: Error? {
            guard let code = Int(self.code) else {
                return nil
            }

            if let selectedError = Error(rawValue: code) {
                return selectedError

            }
            return Error.unknown
        }

        var code: String
        var message: String
    }
}

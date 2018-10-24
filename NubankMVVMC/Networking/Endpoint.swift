//
//  Endpoint.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import Foundation

public class Endpoint {
    
    /// A tuple that recieves an URI and the http request method
    typealias EndpointType = (uri: String, method: String)
    
    /// Contains the http method String simplified for
    struct HTTPMethod {
        static let get    = "GET"
        static let post   = "POST"
        static let update = "UPDATE"
        static let delete = "DELETE"
        static let head   = "HEAD"
        static let put    = "PUT"

    }

    // MARK: Endpoints
    struct Jokes {
        static let random: EndpointType               = (uri: "/jokes/random", method: HTTPMethod.get)
    }
    
}

//
//  HomeRequests.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import UIKit

class HomeRequests: Requester  {
    
    /// Call to get random joke
    ///
    /// - Parameters:
    ///   - no parameters
    /// - Returns: Joke
    func getRandomJoke(success: @escaping CompletionWithSuccess<Joke>,
                       failure: @escaping CompletionWithFailure) {
        
        let header  = HeaderHandler().generate(header: .basic)
        let url     = urlComposer(using: Endpoint.Jokes.random)
        let request = requestComposer(using: url,
                                      headers: header)
        
        dataTask(using: request) { [weak self] (data, error) in
            if error == nil && data != nil {
                let jokeObject = self?.JSONDecode(to: Joke.self, from: data!)
                guard let joke = jokeObject else {
                    failure(ErrorHandler.ErrorResponse(errors: [ErrorHandler.ErrorMessage(code: "\(ErrorHandler.Error.parseError.rawValue)",
                        message: AlertMessages.parseError)]))
                    return
                }
                debugPrint("\(joke)")
                success(joke)
            } else {
                guard let error = error else {
                    return
                }
                failure(error)
            }
        }
    }
}

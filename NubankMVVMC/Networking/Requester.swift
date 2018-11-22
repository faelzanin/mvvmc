//
//  Requester.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

/// Closure that get the success requested object
/// - Parameter: object: Value (Generic)
typealias CompletionWithSuccess<Value> = ( (_ object: Value) -> Void )
typealias CompletionSuccess = ( () -> Void )

/// Closure that get the error
/// - Parameter: failure: Error
typealias CompletionWithFailure    = ( (_ failure: ErrorHandler.ErrorResponse) -> Void )
typealias CompletionFailure = ( () -> Void )

class Requester {
    /// Variable that stores the environmet parâmeter.
    let env: String
    
    weak var task: URLSession?
    
    /// Initializer with the selected environment
    /// - Parameter: environment: API.Environment
    init(withEnvironment environment: API.Environment) {
        env  = environment.getValue()
        task = URLSession.shared
    }
    
    /// Return the full URI to deal with the request
    /// - Parameter: endpoint: The given endpoint in String Format
    func urlComposer(using endpoint: Endpoint.EndpointType) -> (url: URL?, method: String) {
        let url = (url: URL(string: "\(env)\(endpoint.uri)"), method: endpoint.method)
        return url
    }
    
    func urlComposer(using endpoint: Endpoint.EndpointType, complement: String) -> (url: URL?, method: String) {
        let url = (url: URL(string: "\(env)\(endpoint.uri)/\(complement)"), method: endpoint.method)
        return url
    }
    
    /// Create an URLRequest Object with the given URL
    ///
    /// - Parameters:
    ///   - urlEndpoint: URL - The full URL to be requested
    ///   - headers: HeaderHandler.Header - The request headers
    ///   - body: [String: String] - The request body
    /// - Returns: URLRequest
    func requestComposer(using urlEndpoint: (url: URL?, method: String),
                         headers: HeaderHandler.Header,
                         body: [String: Any]? = nil) -> URLRequest {
        #if DEVELOPMENT
        let token =  MockTokenManager.read().trimmingCharacters(in: .whitespaces)
        let supl = (token.isEmpty || token == " ") ? "" : "?token=\(token)"
        let url = URL(string: "\(urlEndpoint.url!.absoluteString)\(supl)")
        var request                 = URLRequest(url: url!)
        #else
        var request                 = URLRequest(url: urlEndpoint.url!)
        #endif
        request.allHTTPHeaderFields = headers
        request.httpMethod          = urlEndpoint.method
        
        if let body = body {
            if urlEndpoint.method == "GET" {
                var getParams = "?"
                for key in body.keys {
                    getParams += "\(key)=\(body[key]!)&"
                }
                let lastChar  = getParams.index(getParams.endIndex, offsetBy: -1)
                let getParam = String(getParams[..<lastChar])
                let urlEndpoint = urlEndpoint.url!.absoluteString + getParam
                request.url = URL(string: urlEndpoint)
            } else {
                let jsonData                = try? JSONSerialization.data(withJSONObject: body)
                request.httpBody            = jsonData
            }
        }
        
        return request
    }
    
    /// Session Configuration for all requests
    ///
    /// - Returns: URLSessionConfiguration
    func sessionConfigComposer() -> URLSessionConfiguration {
        let config                       = URLSessionConfiguration.default
        
        // timeout interval of 60s for request.
        config.timeoutIntervalForRequest = 60.0
        
        if #available(iOS 11.0, *) {
            config.waitsForConnectivity      = false
        }
        
        config.httpCookieAcceptPolicy    = .always
        config.httpShouldSetCookies      = true
        
        return config
    }
    
    /// Generate the request using the given URLRequest
    ///
    /// - Parameters:
    ///   - request: URLRequest - The given request
    ///   - completion: (Data?, Error?)->Void The completion block that use the created task to do the job
    func dataTask(using request: URLRequest,
                  completion: @escaping (( _ data: Data?, _ error: ErrorHandler.ErrorResponse?) -> Void )) {
        
        if Reachability.isConnectedToNetwork() {
            task!.dataTask(with: request, completionHandler: { (data, response, error) in
                
                let error = self.checkForResponseErrors(using: data, andError: error, response)
                self.debugResponse(request, data, response, error)
                if error == nil && data == nil {
                    let err = ErrorHandler.ErrorMessage(code: "-1004", message: AlertMessages.cannotConnect)
                    completion(data, ErrorHandler.ErrorResponse(errors: [err]))
                    return
                }
                completion(data, error)
            }).resume()
        } else {
            let err = ErrorHandler.ErrorMessage(code: "-1009", message: "Sem conexão com a internet.")
            completion(nil, ErrorHandler.ErrorResponse(errors: [err]))
        }
    }
    
    /// Generate the request using the given URLRequest and return URLResponse
    ///
    /// - Parameters:
    ///   - request: URLRequest - The given request
    ///   - completion: (Data?, Error?)->Void The completion block that use the created task to do the job
    func dataTask(using request: URLRequest,
                  completion: @escaping (( _ data: Data?, _ response: URLResponse?, _ error: ErrorHandler.ErrorResponse?) -> Void )) {
        if Reachability.isConnectedToNetwork() {
            task!.dataTask(with: request, completionHandler: { (data, response, error) in
                let error = self.checkForResponseErrors(using: data, andError: error, response)
                self.debugResponse(request, data, response, error)
                if error == nil && data == nil {
                    let err = ErrorHandler.ErrorMessage(code: "-1004", message: AlertMessages.cannotConnect)
                    completion(data, response, ErrorHandler.ErrorResponse(errors: [err]))
                    return
                }
                completion(data, response, error)
            }).resume()
        } else {
            let err = ErrorHandler.ErrorMessage(code: "-1009", message: "Sem conexão com a internet.")
            completion(nil, nil, ErrorHandler.ErrorResponse(errors: [err]))
        }
    }
    
    func dataTask<T: Codable>(
        using request: URLRequest,
        success: @escaping (( _ response: T) -> Void ),
        failure: @escaping ((_ error: ErrorHandler.ErrorResponse) -> Void )
        ) {
        
        if Reachability.isConnectedToNetwork() {
            
            self.dataTask(using: request) { (data, error) in
                if error == nil {
                    guard let data = data else {return}
                    
                    guard let responseDecoded = self.JSONDecode(to: T.self, from: data) else {
                        failure(ErrorHandler.ErrorResponse(errors: [ErrorHandler.ErrorMessage(code:
                            "\(ErrorHandler.Error.parseError.rawValue)",
                            message: AlertMessages.parseError)]))
                        return
                    }
                    
                    success(responseDecoded)
                } else {
                    failure(error!)
                }
            }
            
        } else {
            let err = ErrorHandler.ErrorMessage(code: "-1009", message: "Sem conexão com a internet.")
            failure(ErrorHandler.ErrorResponse(errors: [err]))
        }
    }
    
    func debugResponse(_ request: URLRequest, _ data: Data?, _ response: URLResponse?, _ error: ErrorHandler.ErrorResponse?) {
        
        #if DEBUG
        print("\n🚀 URL: \(request.url?.absoluteString ?? "")\n")
        if let httpResponse = response as? HTTPURLResponse {
            print("🔢 StatusCode: \(httpResponse.statusCode)\n")
            switch httpResponse.statusCode {
            case 200...202:
                print("✅ URL: \(request.url?.absoluteString ?? "")\n")
                if error != nil {
                    print("\(error?.errors.first.debugDescription ?? "")\n")
                } else {
                    print("\(String(data: data ?? Data(), encoding: .utf8) ?? "")\n")
                }
            case 400...505:
                print("❌ URL: \(request.url?.absoluteString ?? "")\n")
                if error != nil {
                    print("\(error?.errors.first.debugDescription ?? "")\n")
                } else {
                    print("\(String(data: data ?? Data(), encoding: .utf8) ?? "")\n")
                }
            default:
                print("❗URL: \(request.url?.absoluteString ?? "")\n")
                if error != nil {
                    print("\(error?.errors.first.debugDescription ?? "")\n")
                } else {
                    print("\(String(data: data ?? Data(), encoding: .utf8) ?? "")\n")
                }
            }
        }
        #endif
        
    }
    
    /// Basic parser to easily deal with object parse
    ///
    /// - Parameters:
    ///   - object: T - The Object type
    ///   - data: Data - The data that will be parsed to object
    /// - Returns: T?
    func JSONDecode<T: Codable>(to object: T.Type, from data: Data) -> T? {
        //        let dict = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        do {
            let object = try JSONDecoder().decode(T.self, from: data) as T
            return object
        } catch let error {
            if object != ErrorHandler.ErrorResponse.self {
                #if DEVELOPMENT
                print("\n❓JSONDecoder -> \(T.self): \(error)\n")
                #endif
            }
            
            return nil
        }
    }
    
    /// Checks for response errors based on status code
    ///
    /// - Parameter response: HTTPURLResponse - The HTTP response sended by the URLSession Request
    /// - Returns: ErrorHandler.Error? - Error handler enum
    func checkForResponseErrors(using data: Data?, andError error: Error? = nil, _ response: URLResponse?) -> ErrorHandler.ErrorResponse? {
        guard let data = data else {
            return nil
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200...202:
                return  nil
            default: break
                
            }
        }
        let errorCheck = JSONDecode(to: ErrorHandler.ErrorMessage.self, from: data)
        
        guard let responseError = errorCheck else { return nil }
        
        let errorArr: ErrorHandler.ErrorResponse = ErrorHandler.ErrorResponse(errors: [responseError])
        
        return errorArr
    }
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0,
                                      sin_family: 0,
                                      sin_port: 0,
                                      sin_addr: in_addr(s_addr: 0),
                                      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

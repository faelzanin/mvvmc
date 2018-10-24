//
//  HeaderHandler.swift
//  NubankMVVMC
//
//  Created Rafael Zanin on 23/10/2018.
//  Copyright © 2018 Rafael Zanin. All rights reserved.
//

import Foundation

struct HeaderHandler {
    typealias Header = [String: String]

    enum HeaderType {
        case basic
        case authenticaded
        case custom([String: String])
    }
    
    // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
    // Example: `App/1.0 (abc.bundle.com); build:1; iOS 10.0.0)`
    let userAgent: String = {
        if let info = Bundle.main.infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
            
            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                
                let osName: String = {
                    #if os(iOS)
                        return "iOS"
                    #elseif os(watchOS)
                        return "watchOS"
                    #elseif os(tvOS)
                        return "tvOS"
                    #elseif os(macOS)
                        return "OS X"
                    #elseif os(Linux)
                        return "Linux"
                    #else
                        return "Unknown"
                    #endif
                }()
                
                return "\(osName) \(versionString)"
            }()
            
            return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion))"
        }
        
        return "MVVMC"
    }()

    func generate(header: HeaderType) -> [String: String] {
        switch header {
        case .basic:
            return self.getBasicHeader()

        case .authenticaded:
            return self.getAuthenticadedHeader()

        case .custom(let customHeader):
            return getCustomHeader(using: customHeader)
        }
    }

    // MARK: Header builder
    private func getBasicHeader() -> Header {
        let dictionary = ["Content-Type": "application/json",
                          "User-Agent": userAgent]
        return dictionary
    }

    private func getAuthenticadedHeader() -> Header {
        var dictionary = getBasicHeader()
        dictionary["AuthToken"] = ""
        return dictionary
    }

    private func getCustomHeader(using dictionary: [String: String]) -> Header {
        return dictionary
    }

}

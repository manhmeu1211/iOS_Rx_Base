//
//  APIConfig.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import Foundation
    
struct APIConfig {
    static var baseUrl: String {
        return "https://newsapi.org/v2/"
    }
    
    // The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
        case OS = "os"
        case versionApp = "version"
        case timezone = "X-TZ-Offset"
    }
    
    // The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
    
    struct ValueHeader {
        var bearer: String {
            return "Bearer "
        }
        static let os = "iOS"
        static var version: String? {
            return appVersion()
        }
    }
}

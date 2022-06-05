//
//  APIError.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import Foundation

struct APIError {
    
    static let defaultErrorCode              = 9999
    static let parsingDataErrorCode          = 6666
    static let invalidSSL                    = -1202
    static let noInternetConnection          = -1009
    static let unauthorized                  = Localized.Error.unauthorized
    static let parseDataError                = Localized.Error.parseDataError
    static let internalServerError           = Localized.Error.internalServerError
    static let serviceTemporarilyUnavailable = Localized.Error.serviceTemporarilyUnavailable
    static let defaultError                  = Localized.Error.defaultError
    static let forbiden                      = Localized.Error.forbiden
    static let notFound                      = Localized.Error.notFound
    static let somethingWrong                = Localized.validation.somethingWrong
    
    static func error(_ statusCode: Int?) -> Error {
        let _statusCode = statusCode ?? defaultErrorCode
        switch statusCode {
        case 6666:
            return errorForStatusCode(statusCode: _statusCode, errorDescription: self.parseDataError)
        case 401:
            return errorForStatusCode(statusCode: _statusCode, errorDescription: self.unauthorized)
        case 403:
            return errorForStatusCode(statusCode: _statusCode, errorDescription: self.forbiden)
        case 404:
           return errorForStatusCode(statusCode: _statusCode, errorDescription: self.notFound)
        case 500:
            return errorForStatusCode(statusCode: _statusCode, errorDescription: self.internalServerError)
        case 503:
            return errorForStatusCode(statusCode: _statusCode, errorDescription: self.serviceTemporarilyUnavailable)
        default:
            return errorForStatusCode(statusCode: self.defaultErrorCode, errorDescription: self.defaultError)
        }
    }
    
    static func errorForStatusCode(statusCode: Int, errorDescription: String) -> Error {
        return NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorDescription ])
    }
}

public struct APIInvalidResponseError: LocalizedError {
    
    public init() {
        
    }
    
    public var errorDescription: String? {
        return NSLocalizedString("api.invalidResponseError",
                                 value: "Invalid server response",
                                 comment: "")
    }
}

public struct APIUnknownError: LocalizedError {
    
    public let statusCode: Int?
    
    public init(statusCode: Int?) {
        self.statusCode = statusCode
    }
    
    public var errorDescription: String? {
        return NSLocalizedString("api.unknownError",
                                 value: "Unknown API error",
                                 comment: "")
    }
}

public struct RequestError: LocalizedError {
    public let statusCode: Int?
    public let message: String?
    
    public init(statusCode: Int?, message: String?) {
        self.statusCode = statusCode
        self.message = message
    }
    
    public var errorDescription: String? {
        return NSLocalizedString("api.requestError",
                                 value: message ?? "",
                                 comment: "")
    }
}

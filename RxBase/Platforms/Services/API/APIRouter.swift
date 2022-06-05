//
//  APIRouter.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case news(_ q: String, from: String, sortBy: String, apiKey: String)
    
    case uploadImage(image: UIImage)

    var baseURL: String {
        switch self {
        case .news, .uploadImage:
            return APIConfig.baseUrl
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Header
        
        urlRequest.setValue(APIConfig.ContentType.json.rawValue,
                            forHTTPHeaderField: APIConfig.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(APIConfig.ContentType.json.rawValue,
                            forHTTPHeaderField: APIConfig.HttpHeaderField.contentType.rawValue)
        urlRequest.setValue(APIConfig.ValueHeader.version,
                            forHTTPHeaderField: APIConfig.HttpHeaderField.versionApp.rawValue)
        urlRequest.setValue(APIConfig.ValueHeader.os,
                            forHTTPHeaderField: APIConfig.HttpHeaderField.OS.rawValue)
        urlRequest.setValue(APIConfig.ValueHeader().bearer,
                            forHTTPHeaderField: APIConfig.HttpHeaderField.authentication.rawValue)
        
        let seconds = TimeZone.current.secondsFromGMT()
        let minutes = seconds / 60
        let tz = String(format: "%+.2d", minutes)
        urlRequest.setValue(tz, forHTTPHeaderField: APIConfig.HttpHeaderField.timezone.rawValue)
        // timeout
        urlRequest.timeoutInterval = TimeInterval(15)
        
        // Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    // MARK: - HttpMethod
    // This returns the HttpMethod type. It's used to determine the type if several endpoints are peresent
    private var method: HTTPMethod {
        switch self {
        case .news:
            return .get
        case .uploadImage:
            return .post
        }
    }
    
    private var path: String {
        switch self {
        case .news:
            return EndPoint.new
        case .uploadImage:
            return EndPoint.new
        }
    }
    
    // MARK: - Parameters
    // This is the queries part, it's optional because an endpoint can be without parameters
    private var parameters: Parameters? {
        var params: [String: Any] = [:]
        switch self {
        case let .news(q, from, sortBy, apiKey):
            params[JSONKey.q] = q
            params[JSONKey.from] = from
            params[JSONKey.sortBy] = sortBy
            params[JSONKey.apiKey] = apiKey
            return params
        case .uploadImage:
            return params
        }
    }
}

extension APIRouter {
    func multipartFormData() -> MultipartFormData {
        let multipartFormData = MultipartFormData()
        switch self {
        case let .uploadImage(image):
            if let imageData = image.compressedData(.medium) {
                multipartFormData.append(imageData,
                                         withName: "media",
                                         fileName: "image.jpeg",
                                         mimeType: "image/jpeg")
            }
        default:
            break
        }
        return multipartFormData
    }
}

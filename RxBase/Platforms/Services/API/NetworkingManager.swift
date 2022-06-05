//
//  NetworkingManager.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import Foundation
import Alamofire

enum NetworkingManager {
    static let maxAttempts = 3
    static let disposeBag = DisposeBag()
    // MARK: - The request function to get results in an Observable
    static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        // Create an RxSwift observable, which will be the one to call the request when subscribed to
        Logger.info("REQUEST: " + (String(describing: urlConvertible.urlRequest?.url)))
        return Observable<T>.create { observer in
            // Trigger the HttpRequest using AlamoFire (AF)
            let request = AF.request(urlConvertible)
                .validate(statusCode: 200..<300)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        // Everything is fine, return the value in onNext
                        guard let jsondData = try? JSONSerialization.data(withJSONObject: value, options: []),
                              let data = try? decoder.decode(T.self, from: jsondData) else {
                            Logger.info("Parsing data error: " +
                                            (String(describing: urlConvertible.urlRequest?.url))
                                            + "value: \(value)")
                            observer.onError(APIError.error(APIError.parsingDataErrorCode))
                            return
                        }
                        observer.onNext(data)
                        observer.onCompleted()
                        return
                    case .failure(let error):
                        if let jsonData = response.data,
                           let data = try? JSONDecoder().decode(ResponseData<String>.self, from: jsonData) {
                            return observer.onError(
                                RequestError(
                                    statusCode: 0,
                                    message: data.status
                                )
                            )
                        }
                        // Something went wrong, switch on the status code and return the error
                        if let statusCode = response.response?.statusCode {
                            observer.onError(APIError
                                                .error(statusCode))
                            return
                        }
                        if let afError = error.asAFError {
                            switch afError {
                            case .sessionTaskFailed(let sessionError):
                                if let urlError = sessionError as? URLError {
                                    observer.onError(APIError.error(urlError.errorCode))
                                    return
                                }
                            default:
                                break
                            }
                        }
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func upload<T: Codable>(router: APIRouter) -> Observable<T> {
        // Create an RxSwift observable, which will be the one to call the request when subscribed to
        Logger.info("LINK REQUEST: " + (String(describing: router.urlRequest?.url)))
        return Observable<T>.create { observer in
            // Trigger the HttpRequest using AlamoFire (AF)
            let request = AF.upload(multipartFormData: router.multipartFormData(), with: router)
                .validate(statusCode: 200..<300)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        // Everything is fine, return the value in onNext
                        guard let jsondData = try? JSONSerialization.data(withJSONObject: value, options: []),
                              let data = try? decoder.decode(T.self, from: jsondData) else {
                            Logger.info("Parsing data error: " +
                                            (String(describing: router.urlRequest?.url))
                                            + "value: \(value)")
                            observer.onError(APIError.error(APIError.parsingDataErrorCode))
                            return
                        }
                        observer.onNext(data)
                        observer.onCompleted()
                        return
                    case .failure(let error):
                        if let jsonData = response.data,
                           let data = try? JSONDecoder().decode(ResponseData<String>.self, from: jsonData) {
                            return observer.onError(RequestError(statusCode: nil, message: data.status))
                        }
                        Logger.info("Error: \(response.response?.description ?? "")")
                        // Something went wrong, switch on the status code and return the error
                        if let statusCode = response.response?.statusCode {
                            observer.onError(APIError
                                                .error(statusCode))
                            return
                        }
                        if let afError = error.asAFError {
                            switch afError {
                            case .sessionTaskFailed(let sessionError):
                                if let urlError = sessionError as? URLError {
                                    observer.onError(APIError.error(urlError.errorCode))
                                    return
                                }
                            default:
                                break
                            }
                        }
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private static var decoder: JSONDecoder = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        // Trong trường hơp có nhiều date format từ api thì thêm vào array này
        let dateFormats: [Format] = [.fullTimeFromServerFirst, .fullTimeFromServerSecond]
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            for format in dateFormats {
                formatter.dateFormat = format.rawValue
                if let date = formatter.date(from: dateString) {
                    return date
                }
            }
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Cannot decode date string \(dateString)")
        }
        return decoder
    }()

    static func renewToken(_ urlConvertible: URLRequestConvertible) -> Observable<ResponseData<Token>> {
        return Observable.create { observer in
            let request = AF.request(urlConvertible)
                .validate(statusCode: 200..<300)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        guard let jsondData = try? JSONSerialization.data(withJSONObject: value, options: []),
                            let data = try? decoder.decode(ResponseData<Token>.self, from: jsondData) else {
                                observer.onError(APIError.error(APIError.parsingDataErrorCode))
                                return
                        }
                        observer.onNext(data)
                        observer.onCompleted()
                        return
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

//
//  Localized.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

enum Localized {
    enum Error {
        static var title: String { return "Error".localized }
        static var emptyData: String { return "Error.emptyData".localized }
        static var messageError: String { return "Common.Error.Message".localized }
        static var cantConectToStream: String { return "Error.cantconnecToStream".localized }
        static var unauthorized: String { return "error.unauthorized".localized }
        static var internalServerError: String { return "error.internalServerError".localized }
        static var parseDataError: String { return "error.parseDataError".localized }
        static var serviceTemporarilyUnavailable: String { return "error.serviceTemporarilyUnavailable".localized }
        static var defaultError: String { return "error.defaultError".localized }
        static var forbiden: String { return "error.forbiden".localized }
        static var notFound: String { return "error.notFound".localized }
    }
    
    enum validation {
        static var empty: String { return "validation.error.empty".localized }
        static var somethingWrong: String { return "somethingWrong".localized }

    }
    
    enum headers {
        
    }
    
}

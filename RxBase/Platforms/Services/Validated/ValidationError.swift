//
//  LoginError.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//


enum ValidationErr: ValidationError {
    case empty
}

extension ValidationErr {
    var message: String {
        switch self {
        case .empty:
            return Localized.validation.empty
        }
    }
}

extension ValidationErr: Error {}

extension ValidationErr: LocalizedError {
    var errorDescription: String? {
        return message
    }
}

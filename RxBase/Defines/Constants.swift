//
//  Constants.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

let keyChain = KeychainWrapper.standard

enum DataName {
    static let user = "RUser"
}

enum Title {
    static let error = "Error"
    static let ok = "OK"
    static let login = "Login"
}

enum JSONKey {
    static let perPage = "per_page"
    static let page = "page"
    static let limit = "limit"
    static let q = "q"
    static let apiKey = "apiKey"
    static let from = "from"
    static let sortBy = "sortBy"
}

enum Constants {
    static let versionApp = "CFBundleShortVersionString"
}


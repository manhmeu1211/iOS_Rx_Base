//
//  Screen.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//


enum Screen {
    private static let bounds = UIScreen.main.bounds
    static let width = bounds.size.width
    static let height = bounds.size.height
    static let windowSafeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets
    static let topArea = windowSafeAreaInsets?.top
}

enum CurrentCountry {
    static let currentCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
}

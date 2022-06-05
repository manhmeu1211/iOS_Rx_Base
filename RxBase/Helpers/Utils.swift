//
//  Utils.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

func after(interval: TimeInterval, completion: (() -> Void)?) {
    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
        completion?()
    }
}

func appVersion() -> String? {
    return Bundle.main.object(forInfoDictionaryKey: Constants.versionApp) as? String
}

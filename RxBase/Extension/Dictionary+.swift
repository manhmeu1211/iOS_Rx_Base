//
//  Dictionary+.swift
///  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

extension Dictionary {
    func compactMapValues<U>(_ transform: (Value) throws -> U?) rethrows -> [Key: U] {
        var result = [Key: U]()
        for (key, value) in self {
            result[key] = try transform(value)
        }
        return result
    }
}

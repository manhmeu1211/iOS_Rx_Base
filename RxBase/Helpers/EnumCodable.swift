//
//  EnumCodable.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import Foundation

protocol EnumCodable: Codable, RawRepresentable {
    static var unknownValue: Self { get }
}

extension EnumCodable where Self.RawValue == Int {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.unknownValue
    }
}

extension EnumCodable where Self.RawValue == String {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.unknownValue
    }
}

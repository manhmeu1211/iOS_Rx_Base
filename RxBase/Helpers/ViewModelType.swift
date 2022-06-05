//
//  ViewModelType.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//


public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}

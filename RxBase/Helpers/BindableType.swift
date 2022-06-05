//
//  BindableType.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//


import UIKit
import RxSwift

public protocol BindableType: class {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    public func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}

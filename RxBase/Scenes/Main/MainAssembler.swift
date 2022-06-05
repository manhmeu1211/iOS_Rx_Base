//
//  MainAssembler.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import UIKit
import Reusable

protocol MainAssembler {
    func resolve(navigationController: UINavigationController) -> MainViewController
    func resolve(navigationController: UINavigationController) -> MainViewModel
    func resolve(navigationController: UINavigationController) -> MainNavigatorType
    func resolve() -> MainUseCaseType
}

extension MainAssembler where Self: DefaultAssembler {
    
    func resolve(navigationController: UINavigationController) -> MainViewController {
        let vc = MainViewController()
        let vm: MainViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> MainViewModel {
        return MainViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
    
    func resolve(navigationController: UINavigationController) -> MainNavigatorType {
        return MainNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> MainUseCaseType {
        return MainUseCase(newRepo: resolve())
    }
}

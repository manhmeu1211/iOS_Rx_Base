//
//  AppViewModel.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

struct AppViewModel {
    let navigator: AppNavigatorType
    let useCase: AppUseCaseType
}

// MARK: - ViewModelType
extension AppViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let toMain: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let toMain = input.loadTrigger
            .mapToVoid()
            .do(onNext: self.navigator.toMain)
        
        return Output(toMain: toMain)
    }
}

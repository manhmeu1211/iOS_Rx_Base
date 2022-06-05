//
//  MainViewModel.swift
//  BaseRxSwift
//
//
//  Created by Lương Mạnh on 14/03/2022.
//


// swiftlint:disable all
struct MainViewModel {
    let navigator: MainNavigatorType
    let useCase: MainUseCaseType
}

// MARK: - ViewModelType
extension MainViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>

    }
    
    struct Output {
        let loadTrigger: Driver<[News]>

    }
    
    func transform(_ input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let indicator = ActivityIndicator()
        
        let fetchNew = input.loadTrigger.flatMapLatest {
            useCase.fetchNews(page: 1)
                .compactMap { $0.articles }
                .asDriver(onErrorJustReturn: [])
        }
        return Output(loadTrigger: fetchNew)
    }
}

//
//  MainUseCase.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

protocol MainUseCaseType {
    func fetchNews(page: Int) -> Observable<ResponseData<[News]>>
}

struct MainUseCase: MainUseCaseType {
    let newRepo: NewsRepositoryType

    func fetchNews(page: Int) -> Observable<ResponseData<[News]>> {
        return newRepo.getNews()
    }    
}

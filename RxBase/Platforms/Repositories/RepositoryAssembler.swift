//
//  RepositoryAssembler.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

protocol RepositoriesAssembler {
    func resolve() -> RepoRepositoryType
    func resolve() -> NewsRepositoryType
}

extension RepositoriesAssembler where Self: DefaultAssembler {
    func resolve() -> RepoRepositoryType {
        return RepoRepository()
    }
    
    func resolve() -> NewsRepositoryType {
        return NewsRepository()
    }
    
}

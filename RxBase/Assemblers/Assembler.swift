//
//  Assembler.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

protocol Assembler: class,
    MainAssembler,
    RepositoriesAssembler,
    AppAssembler {
}

final class DefaultAssembler: Assembler {
    
}

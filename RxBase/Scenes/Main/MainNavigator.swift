//
//  MainNavigator.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//


protocol MainNavigatorType {
     
}

struct MainNavigator: MainNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
}

//
//  MainViewController.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import UIKit
import RxCocoa

final class MainViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets

    
    // MARK: - Layout
    
    
    // MARK: - Properties
    
    var viewModel: MainViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {

    }
    
    func bindViewModel() {
        let input = MainViewModel.Input(loadTrigger: Driver.just(()))
        
        let output = viewModel.transform(input)
        
        output.loadTrigger
            .drive(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Menu TableView
extension MainViewController {
    
   
}

// MARK: - Binder
extension MainViewController {
   
}

// MARK: - StoryboardSceneBased
extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

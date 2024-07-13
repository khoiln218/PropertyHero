//
//  FeedbackEmailAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/28/23.
//

import UIKit
import Reusable

protocol FeedbackEmailAssembler {
    func resolve(navigationController: UINavigationController) -> FeedbackEmailViewController
    func resolve(navigationController: UINavigationController) -> FeedbackEmailViewModel
    func resolve(navigationController: UINavigationController) -> FeedbackEmailNavigatorType
    func resolve() -> FeedbackEmailUseCaseType
}

extension FeedbackEmailAssembler {
    func resolve(navigationController: UINavigationController) -> FeedbackEmailViewController {
        let vc = FeedbackEmailViewController.instantiate()
        let vm: FeedbackEmailViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> FeedbackEmailViewModel {
        return FeedbackEmailViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension FeedbackEmailAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> FeedbackEmailNavigatorType {
        return FeedbackEmailNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> FeedbackEmailUseCaseType {
        return FeedbackEmailUseCase()
    }
}

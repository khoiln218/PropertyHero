//
//  MoreAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit
import Reusable

protocol MoreAssembler {
    func resolve(navigationController: UINavigationController) -> MoreViewController
    func resolve(navigationController: UINavigationController) -> MoreViewModel
    func resolve(navigationController: UINavigationController) -> MoreNavigatorType
    func resolve() -> MoreUseCaseType
}

extension MoreAssembler {
    func resolve(navigationController: UINavigationController) -> MoreViewController {
        let vc = MoreViewController.instantiate()
        let vm: MoreViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> MoreViewModel {
        return MoreViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension MoreAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> MoreNavigatorType {
        return MoreNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> MoreUseCaseType {
        return MoreUseCase(loginGateway: resolve())
    }
}

//
//  AccountDeletionAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/26/23.
//

import UIKit
import Reusable

protocol AccountDeletionAssembler {
    func resolve(navigationController: UINavigationController) -> AccountDeletionViewController
    func resolve(navigationController: UINavigationController) -> AccountDeletionViewModel
    func resolve(navigationController: UINavigationController) -> AccountDeletionNavigatorType
    func resolve() -> AccountDeletionUseCaseType
}

extension AccountDeletionAssembler {
    func resolve(navigationController: UINavigationController) -> AccountDeletionViewController {
        let vc = AccountDeletionViewController.instantiate()
        let vm: AccountDeletionViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> AccountDeletionViewModel {
        return AccountDeletionViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension AccountDeletionAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> AccountDeletionNavigatorType {
        return AccountDeletionNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> AccountDeletionUseCaseType {
        return AccountDeletionUseCase(loginGateway: resolve())
    }
}

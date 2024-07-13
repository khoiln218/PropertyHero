//
//  AccountInfoAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/31/23.
//

import UIKit
import Reusable

protocol AccountInfoAssembler {
    func resolve(navigationController: UINavigationController) -> AccountInfoViewController
    func resolve(navigationController: UINavigationController) -> AccountInfoViewModel
    func resolve(navigationController: UINavigationController) -> AccountInfoNavigatorType
    func resolve() -> AccountInfoUseCaseType
}

extension AccountInfoAssembler {
    func resolve(navigationController: UINavigationController) -> AccountInfoViewController {
        let vc = AccountInfoViewController.instantiate()
        let vm: AccountInfoViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> AccountInfoViewModel {
        return AccountInfoViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension AccountInfoAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> AccountInfoNavigatorType {
        return AccountInfoNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> AccountInfoUseCaseType {
        return AccountInfoUseCase(locationGateway: resolve(), loginGateway: resolve())
    }
}

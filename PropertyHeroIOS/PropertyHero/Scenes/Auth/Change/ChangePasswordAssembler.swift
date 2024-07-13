//
//  ChangePasswordAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/29/23.
//

import UIKit
import Reusable

protocol ChangePasswordAssembler {
    func resolve(navigationController: UINavigationController) -> ChangePasswordViewController
    func resolve(navigationController: UINavigationController) -> ChangePasswordViewModel
    func resolve(navigationController: UINavigationController) -> ChangePasswordNavigatorType
    func resolve() -> ChangePasswordUseCaseType
}

extension ChangePasswordAssembler {
    func resolve(navigationController: UINavigationController) -> ChangePasswordViewController {
        let vc = ChangePasswordViewController.instantiate()
        let vm: ChangePasswordViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> ChangePasswordViewModel {
        return ChangePasswordViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension ChangePasswordAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> ChangePasswordNavigatorType {
        return ChangePasswordNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> ChangePasswordUseCaseType {
        return ChangePasswordUseCase(loginGateway: resolve())
    }
}

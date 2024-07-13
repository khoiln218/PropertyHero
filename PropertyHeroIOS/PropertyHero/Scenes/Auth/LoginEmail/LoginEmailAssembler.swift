//
//  LoginEmailAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/20/23.
//

import UIKit
import Reusable

protocol LoginEmailAssembler {
    func resolve(navigationController: UINavigationController) -> LoginEmailViewController
    func resolve(navigationController: UINavigationController) -> LoginEmailViewModel
    func resolve(navigationController: UINavigationController) -> LoginEmailNavigatorType
    func resolve() -> LoginEmailUseCaseType
}

extension LoginEmailAssembler {
    func resolve(navigationController: UINavigationController) -> LoginEmailViewController {
        let vc = LoginEmailViewController.instantiate()
        let vm: LoginEmailViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> LoginEmailViewModel {
        return LoginEmailViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension LoginEmailAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> LoginEmailNavigatorType {
        return LoginEmailNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> LoginEmailUseCaseType {
        return LoginEmailUseCase(loginGateway: resolve())
    }
}

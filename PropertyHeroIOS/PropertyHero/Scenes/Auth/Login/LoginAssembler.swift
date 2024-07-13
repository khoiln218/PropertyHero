//
//  LoginAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/4/23.
//

import UIKit
import Reusable

protocol LoginAssembler {
    func resolve(navigationController: UINavigationController) -> LoginViewController
    func resolve(navigationController: UINavigationController) -> LoginViewModel
    func resolve(navigationController: UINavigationController) -> LoginNavigatorType
    func resolve() -> LoginUseCaseType
}

extension LoginAssembler {
    func resolve(navigationController: UINavigationController) -> LoginViewController {
        let vc = LoginViewController.instantiate()
        let vm: LoginViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> LoginViewModel {
        return LoginViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension LoginAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> LoginNavigatorType {
        return LoginNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> LoginUseCaseType {
        return LoginUseCase(loginGateway: resolve())
    }
}

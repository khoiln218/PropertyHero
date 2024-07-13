//
//  ProfileAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/26/23.
//

import UIKit
import Reusable

protocol ProfileAssembler {
    func resolve(navigationController: UINavigationController, account: Account) -> ProfileViewController
    func resolve(navigationController: UINavigationController, account: Account) -> ProfileViewModel
    func resolve(navigationController: UINavigationController) -> ProfileNavigatorType
    func resolve() -> ProfileUseCaseType
}

extension ProfileAssembler {
    func resolve(navigationController: UINavigationController, account: Account) -> ProfileViewController {
        let vc = ProfileViewController.instantiate()
        let vm: ProfileViewModel = resolve(navigationController: navigationController, account: account)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, account: Account) -> ProfileViewModel {
        return ProfileViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            account: account
        )
    }
}

extension ProfileAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> ProfileNavigatorType {
        return ProfileNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> ProfileUseCaseType {
        return ProfileUseCase(loginGateway: resolve())
    }
}

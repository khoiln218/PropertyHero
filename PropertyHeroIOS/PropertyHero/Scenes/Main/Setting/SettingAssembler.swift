//
//  SettingAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/2/23.
//

import UIKit
import Reusable

protocol SettingAssembler {
    func resolve(navigationController: UINavigationController) -> SettingViewController
    func resolve(navigationController: UINavigationController) -> SettingViewModel
    func resolve(navigationController: UINavigationController) -> SettingNavigatorType
    func resolve() -> SettingUseCaseType
}

extension SettingAssembler {
    func resolve(navigationController: UINavigationController) -> SettingViewController {
        let vc = SettingViewController.instantiate()
        let vm: SettingViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> SettingViewModel {
        return SettingViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension SettingAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> SettingNavigatorType {
        return SettingNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> SettingUseCaseType {
        return SettingUseCase(locationGateway: resolve())
    }
}

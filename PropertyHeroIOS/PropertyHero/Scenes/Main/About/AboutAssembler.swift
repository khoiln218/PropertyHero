//
//  AboutAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/2/23.
//

import UIKit
import Reusable

protocol AboutAssembler {
    func resolve(navigationController: UINavigationController) -> AboutViewController
    func resolve(navigationController: UINavigationController) -> AboutViewModel
    func resolve(navigationController: UINavigationController) -> AboutNavigatorType
    func resolve() -> AboutUseCaseType
}

extension AboutAssembler {
    func resolve(navigationController: UINavigationController) -> AboutViewController {
        let vc = AboutViewController.instantiate()
        let vm: AboutViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> AboutViewModel {
        return AboutViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension AboutAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> AboutNavigatorType {
        return AboutNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> AboutUseCaseType {
        return AboutUseCase()
    }
}

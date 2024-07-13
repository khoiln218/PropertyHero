//
//  AdsDetailAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/24/23.
//

import UIKit
import Reusable

protocol AdsDetailAssembler {
    func resolve(navigationController: UINavigationController, relocation: Relocation) -> AdsDetailViewController
    func resolve(navigationController: UINavigationController, relocation: Relocation) -> AdsDetailViewModel
    func resolve(navigationController: UINavigationController) -> AdsDetailNavigatorType
    func resolve() -> AdsDetailUseCaseType
}

extension AdsDetailAssembler {
    func resolve(navigationController: UINavigationController, relocation: Relocation) -> AdsDetailViewController {
        let vc = AdsDetailViewController.instantiate()
        let vm: AdsDetailViewModel = resolve(navigationController: navigationController, relocation: relocation)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, relocation: Relocation) -> AdsDetailViewModel {
        return AdsDetailViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            relocation: relocation
        )
    }
}

extension AdsDetailAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> AdsDetailNavigatorType {
        return AdsDetailNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> AdsDetailUseCaseType {
        return AdsDetailUseCase()
    }
}

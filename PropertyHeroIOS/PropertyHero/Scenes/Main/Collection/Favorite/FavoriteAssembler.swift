//
//  FavoriteAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import UIKit
import Reusable

protocol FavoriteAssembler {
    func resolve(navigationController: UINavigationController) -> FavoriteViewController
    func resolve(navigationController: UINavigationController) -> FavoriteViewModel
    func resolve(navigationController: UINavigationController) -> FavoriteNavigatorType
    func resolve() -> FavoriteUseCaseType
}

extension FavoriteAssembler {
    func resolve(navigationController: UINavigationController) -> FavoriteViewController {
        let vc = FavoriteViewController.instantiate()
        let vm: FavoriteViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> FavoriteViewModel {
        return FavoriteViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension FavoriteAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> FavoriteNavigatorType {
        return FavoriteNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> FavoriteUseCaseType {
        return FavoriteUseCase(productGateway: resolve())
    }
}

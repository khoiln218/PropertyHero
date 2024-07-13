//
//  ProductViewAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import UIKit
import Reusable

protocol ProductViewAssembler {
    func resolve(navigationController: UINavigationController) -> ProductViewViewController
    func resolve(navigationController: UINavigationController) -> ProductViewViewModel
    func resolve(navigationController: UINavigationController) -> ProductViewNavigatorType
    func resolve() -> ProductViewUseCaseType
}

extension ProductViewAssembler {
    func resolve(navigationController: UINavigationController) -> ProductViewViewController {
        let vc = ProductViewViewController.instantiate()
        let vm: ProductViewViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> ProductViewViewModel {
        return ProductViewViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension ProductViewAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> ProductViewNavigatorType {
        return ProductViewNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> ProductViewUseCaseType {
        return ProductViewUseCase(productGateway: resolve())
    }
}

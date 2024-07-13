//
//  ProductDetailAssembler.swift
//  Gomi Mall
//
//  Created by KHOI LE on 5/28/21.
//  Copyright © 2021 GomiCorp. All rights reserved.
//

import UIKit

protocol ProductDetailAssembler {
    func resolve(navigationController: UINavigationController, productId: Int) -> ProductDetailViewController
    func resolve(navigationController: UINavigationController, productId: Int) -> ProductDetailViewModel
    func resolve(navigationController: UINavigationController) -> ProductDetailNavigatorType
    func resolve() -> ProductDetailUseCaseType
}

extension ProductDetailAssembler {
    func resolve(navigationController: UINavigationController, productId: Int) -> ProductDetailViewController {
        let vc = ProductDetailViewController.instantiate()
        let vm: ProductDetailViewModel = resolve(navigationController: navigationController, productId: productId)
        vc.bindViewModel(to: vm)
        return vc
    }

    func resolve(navigationController: UINavigationController, productId: Int) -> ProductDetailViewModel {
        return ProductDetailViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            productId: productId
        )
    }
}

extension ProductDetailAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> ProductDetailNavigatorType {
        return ProductDetailNavigator(assembler: self, navigationController: navigationController)
    }

    func resolve() -> ProductDetailUseCaseType {
        return ProductDetailUseCase(productGateway: resolve(), categoryGateway: resolve())
    }
}

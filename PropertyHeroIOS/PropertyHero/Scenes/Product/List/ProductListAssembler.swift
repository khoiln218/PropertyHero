//
//  ProductListAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import UIKit
import Reusable

protocol ProductListAssembler {
    func resolve(navigationController: UINavigationController, searchInfo: SearchInfo, title: String) -> ProductListViewController
    func resolve(navigationController: UINavigationController, searchInfo: SearchInfo, title: String) -> ProductListViewModel
    func resolve(navigationController: UINavigationController) -> ProductListNavigatorType
    func resolve() -> ProductListUseCaseType
}

extension ProductListAssembler {
    func resolve(navigationController: UINavigationController, searchInfo: SearchInfo, title: String) -> ProductListViewController {
        let vc = ProductListViewController.instantiate()
        let vm: ProductListViewModel = resolve(navigationController: navigationController, searchInfo: searchInfo, title: title)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, searchInfo: SearchInfo, title: String) -> ProductListViewModel {
        return ProductListViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            searchInfo: searchInfo,
            title: title
        )
    }
}

extension ProductListAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> ProductListNavigatorType {
        return ProductListNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> ProductListUseCaseType {
        return ProductListUseCase(productGateway: resolve())
    }
}

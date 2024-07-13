//
//  CollectionAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit
import Reusable

protocol CollectionAssembler {
    func resolve(navigationController: UINavigationController) -> CollectionViewController
    func resolve(navigationController: UINavigationController) -> CollectionViewModel
    func resolve(navigationController: UINavigationController) -> CollectionNavigatorType
    func resolve() -> CollectionUseCaseType
}

extension CollectionAssembler {
    func resolve(navigationController: UINavigationController) -> CollectionViewController {
        let vc = CollectionViewController.instantiate()
        let vm: CollectionViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> CollectionViewModel {
        return CollectionViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension CollectionAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> CollectionNavigatorType {
        return CollectionNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> CollectionUseCaseType {
        return CollectionUseCase()
    }
}

//
//  FilterAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/25/23.
//

import UIKit
import RxSwift
import Reusable

protocol FilterAssembler {
    func resolve(navigationController: UINavigationController, delegate: PublishSubject<FilterChangedDelegate>) -> FilterViewController
    func resolve(navigationController: UINavigationController, delegate: PublishSubject<FilterChangedDelegate>) -> FilterViewModel
    func resolve(navigationController: UINavigationController) -> FilterNavigatorType
    func resolve() -> FilterUseCaseType
}

extension FilterAssembler {
    func resolve(navigationController: UINavigationController, delegate: PublishSubject<FilterChangedDelegate>) -> FilterViewController {
        let vc = FilterViewController.instantiate()
        let vm: FilterViewModel = resolve(navigationController: navigationController, delegate: delegate)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, delegate: PublishSubject<FilterChangedDelegate>) -> FilterViewModel {
        return FilterViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            delegate: delegate
        )
    }
}

extension FilterAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> FilterNavigatorType {
        return FilterNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> FilterUseCaseType {
        return FilterUseCase(categoryGateway: resolve())
    }
}

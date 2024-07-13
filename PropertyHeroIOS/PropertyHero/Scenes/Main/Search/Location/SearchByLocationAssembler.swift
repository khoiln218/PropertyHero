//
//  SearchByLocationAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/11/23.
//

import UIKit
import Reusable

protocol SearchByLocationAssembler {
    func resolve(navigationController: UINavigationController) -> SearchByLocationViewController
    func resolve(navigationController: UINavigationController) -> SearchByLocationViewModel
    func resolve(navigationController: UINavigationController) -> SearchByLocationNavigatorType
    func resolve() -> SearchByLocationUseCaseType
}

extension SearchByLocationAssembler {
    func resolve(navigationController: UINavigationController) -> SearchByLocationViewController {
        let vc = SearchByLocationViewController.instantiate()
        let vm: SearchByLocationViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> SearchByLocationViewModel {
        return SearchByLocationViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension SearchByLocationAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> SearchByLocationNavigatorType {
        return SearchByLocationNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> SearchByLocationUseCaseType {
        return SearchByLocationUseCase(locationGateway: resolve())
    }
}

//
//  ReportAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/24/23.
//

import UIKit
import Reusable

protocol ReportAssembler {
    func resolve(navigationController: UINavigationController, productId: Int) -> ReportViewController
    func resolve(navigationController: UINavigationController, productId: Int) -> ReportViewModel
    func resolve(navigationController: UINavigationController) -> ReportNavigatorType
    func resolve() -> ReportUseCaseType
}

extension ReportAssembler {
    func resolve(navigationController: UINavigationController, productId: Int) -> ReportViewController {
        let vc = ReportViewController.instantiate()
        let vm: ReportViewModel = resolve(navigationController: navigationController, productId: productId)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, productId: Int) -> ReportViewModel {
        return ReportViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            productId: productId
        )
    }
}

extension ReportAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> ReportNavigatorType {
        return ReportNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> ReportUseCaseType {
        return ReportUseCase(categoryGateway: resolve())
    }
}

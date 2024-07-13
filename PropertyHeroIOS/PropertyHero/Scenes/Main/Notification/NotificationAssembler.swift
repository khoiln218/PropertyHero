//
//  NotificationAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit
import Reusable

protocol NotificationAssembler {
    func resolve(navigationController: UINavigationController) -> NotificationViewController
    func resolve(navigationController: UINavigationController) -> NotificationViewModel
    func resolve(navigationController: UINavigationController) -> NotificationNavigatorType
    func resolve() -> NotificationUseCaseType
}

extension NotificationAssembler {
    func resolve(navigationController: UINavigationController) -> NotificationViewController {
        let vc = NotificationViewController.instantiate()
        let vm: NotificationViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> NotificationViewModel {
        return NotificationViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension NotificationAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> NotificationNavigatorType {
        return NotificationNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> NotificationUseCaseType {
        return NotificationUseCase()
    }
}

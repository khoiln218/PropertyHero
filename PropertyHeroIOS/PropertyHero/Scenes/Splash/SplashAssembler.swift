//
//  MainAssembler.swift
//  BaoDongThap
//
//  Created by KHOI LE on 9/20/22.
//

import UIKit

protocol SplashAssembler {
    func resolve(window: UIWindow) -> SplashViewController
    func resolve(window: UIWindow) -> SplashViewModel
    func resolve(window: UIWindow) -> SplashNavigatorType
    func resolve() -> SplashUseCaseType
}

extension SplashAssembler {
    func resolve(window: UIWindow) -> SplashViewController {
        let vc = SplashViewController.instantiate()
        let vm: SplashViewModel = resolve(window: window)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(window: UIWindow) -> SplashViewModel {
        return SplashViewModel(
            navigator: resolve(window: window),
            useCase: resolve()
        )
    }
}

extension SplashAssembler where Self: DefaultAssembler {
    func resolve(window: UIWindow) -> SplashNavigatorType {
        return SplashNavigator(assembler: self, window: window)
    }
    
    func resolve() -> SplashUseCaseType {
        return SplashUseCase()
    }
}

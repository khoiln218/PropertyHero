//
//  MainNavigator.swift
//  BaoDongThap
//
//  Created by KHOI LE on 9/20/22.
//

import UIKit

protocol SplashNavigatorType {
    func toMain()
}

struct SplashNavigator: SplashNavigatorType {
    unowned let assembler: Assembler
    unowned let window: UIWindow
    
    func toMain() {
        let nav = UINavigationController()
        let vc: MainViewController = assembler.resolve(navigationController: nav)
        nav.viewControllers.append(vc)
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}


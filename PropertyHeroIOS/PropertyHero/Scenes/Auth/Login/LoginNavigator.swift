//
//  LoginNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/4/23.
//

import UIKit

protocol LoginNavigatorType {
    func toLoginEmail()
    func toRegister()
    func goBack()
}

struct LoginNavigator: LoginNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toLoginEmail() {
        goBack()
        let vc: LoginEmailViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toRegister() {
        goBack()
        let vc: RegisterViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goBack() {
        navigationController.popViewController(animated: false)
    }
}

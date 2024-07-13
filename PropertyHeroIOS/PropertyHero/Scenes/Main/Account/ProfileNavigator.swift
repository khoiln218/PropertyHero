//
//  ProfileNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/26/23.
//

import UIKit

protocol ProfileNavigatorType {
    func backHome()
    func toAccountInfo()
    func toAccountDeletion()
    func toChangePassword()
}

struct ProfileNavigator: ProfileNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func backHome() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func toAccountInfo() {
        let vc: AccountInfoViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toAccountDeletion() {
        let vc: AccountDeletionViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toChangePassword() {
        let vc: ChangePasswordViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
}

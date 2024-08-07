//
//  MoreNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit

protocol MoreNavigatorType {
    func toLogin()
    func toAccountInfo()
    func toFeedback()
    func toSetting()
    func toAbout()
    func toAccountDeletion()
}

struct MoreNavigator: MoreNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toLogin() {
        let vc: LoginViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toAccountInfo() {
        let vc: AccountInfoViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toFeedback() {
        let vc: FeedbackEmailViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toSetting() {
        let vc: SettingViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toAbout() {
        let vc: AboutViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toAccountDeletion() {
        let vc: AccountDeletionViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
}

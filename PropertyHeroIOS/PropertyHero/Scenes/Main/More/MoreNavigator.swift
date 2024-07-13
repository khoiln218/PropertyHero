//
//  MoreNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit

protocol MoreNavigatorType {
    func toLogin()
    func toProfile(_ account: Account)
    func toFeedback()
    func toSetting()
}

struct MoreNavigator: MoreNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toLogin() {
        let vc: LoginViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toProfile(_ account: Account) {
        let vc: ProfileViewController = assembler.resolve(navigationController: navigationController, account: account)
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
}

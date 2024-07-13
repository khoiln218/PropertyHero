//
//  SettingNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/2/23.
//

import UIKit

protocol SettingNavigatorType {
    func toAbout()
}

struct SettingNavigator: SettingNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toAbout() {
        let vc: AboutViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
}

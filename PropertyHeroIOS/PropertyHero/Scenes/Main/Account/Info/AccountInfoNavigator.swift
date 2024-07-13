//
//  AccountInfoNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/31/23.
//

import UIKit

protocol AccountInfoNavigatorType {
    func goBack()
}

struct AccountInfoNavigator: AccountInfoNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}

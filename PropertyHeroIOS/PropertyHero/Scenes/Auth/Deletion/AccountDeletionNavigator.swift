//
//  AccountDeletionNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/26/23.
//

import UIKit

protocol AccountDeletionNavigatorType {
    func backHome()
}

struct AccountDeletionNavigator: AccountDeletionNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func backHome() {
        navigationController.popToRootViewController(animated: true)
    }
}

//
//  ChangePasswordNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/29/23.
//

import UIKit

protocol ChangePasswordNavigatorType {
    func goBack()
}

struct ChangePasswordNavigator: ChangePasswordNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func goBack() {
        navigationController.popViewController(animated: false)
    }
}

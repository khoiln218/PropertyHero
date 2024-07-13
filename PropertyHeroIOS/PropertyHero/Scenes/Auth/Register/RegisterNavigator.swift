//
//  RegisterNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/21/23.
//

import UIKit

protocol RegisterNavigatorType {
    func goBack()
}

struct RegisterNavigator: RegisterNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func goBack() {
        navigationController.popViewController(animated: false)
    }
}

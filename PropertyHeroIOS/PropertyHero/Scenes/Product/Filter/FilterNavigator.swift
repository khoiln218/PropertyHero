//
//  FilterNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/25/23.
//

import UIKit

protocol FilterNavigatorType {
    func goBack()
}

struct FilterNavigator: FilterNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}

//
//  ReportNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/24/23.
//

import UIKit

protocol ReportNavigatorType {
    func goBack()
}

struct ReportNavigator: ReportNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}

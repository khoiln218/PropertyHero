//
//  FeedbackEmailNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/28/23.
//

import UIKit

protocol FeedbackEmailNavigatorType {
    func goBack()
}

struct FeedbackEmailNavigator: FeedbackEmailNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func goBack() {
        navigationController.popViewController(animated: false)
    }
}

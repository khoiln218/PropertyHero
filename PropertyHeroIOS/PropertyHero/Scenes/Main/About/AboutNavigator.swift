//
//  AboutNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/2/23.
//

import UIKit

protocol AboutNavigatorType {
    
}

struct AboutNavigator: AboutNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
}

//
//  AdsDetailNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/24/23.
//

import UIKit

protocol AdsDetailNavigatorType {
    
}

struct AdsDetailNavigator: AdsDetailNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
}

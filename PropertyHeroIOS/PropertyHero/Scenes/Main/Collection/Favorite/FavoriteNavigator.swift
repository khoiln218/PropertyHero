//
//  FavoriteNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import UIKit

protocol FavoriteNavigatorType {
    func toProductDetail(_ productId: Int)
}

struct FavoriteNavigator: FavoriteNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toProductDetail(_ productId: Int) {
        let vc: ProductDetailViewController = assembler.resolve(navigationController: navigationController, productId: productId)
        navigationController.pushViewController(vc, animated: true)
    }
}

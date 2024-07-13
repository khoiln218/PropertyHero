//
//  ProductViewNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import UIKit

protocol ProductViewNavigatorType {
    func toProductDetail(_ productId: Int)
}

struct ProductViewNavigator: ProductViewNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toProductDetail(_ productId: Int) {
        let vc: ProductDetailViewController = assembler.resolve(navigationController: navigationController, productId: productId)
        navigationController.pushViewController(vc, animated: true)
    }
}

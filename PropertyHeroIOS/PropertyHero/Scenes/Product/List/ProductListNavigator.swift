//
//  ProductListNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol ProductListNavigatorType {
    func toProductDetail(_ productId: Int)
    func toFilter() -> Driver<FilterChangedDelegate>
}

struct ProductListNavigator: ProductListNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toProductDetail(_ productId: Int) {
        let vc: ProductDetailViewController = assembler.resolve(navigationController: navigationController, productId: productId)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toFilter() -> Driver<FilterChangedDelegate> {
        let delegate = PublishSubject<FilterChangedDelegate>()
        let vc: FilterViewController = assembler.resolve(navigationController: navigationController, delegate: delegate)
        navigationController.pushViewController(vc, animated: true)
        
        return delegate.asDriverOnErrorJustComplete()
    }
}

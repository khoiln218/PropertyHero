//
//  ProductDetailNavigator.swift
//  Gomi Mall
//
//  Created by KHOI LE on 5/28/21.
//  Copyright © 2021 GomiCorp. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol ProductDetailNavigatorType {
    func toLogin()
    func toReport(_ productId: Int)
    func toAds(_ relocation: Relocation)
    func toSlider(_ product: Product, position: Int)
    func goBack()
}

struct ProductDetailNavigator: ProductDetailNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toLogin() {
        let vc: LoginViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toReport(_ productId: Int) {
        let vc: ReportViewController = assembler.resolve(navigationController: navigationController, productId: productId)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toAds(_ relocation: Relocation) {
        let vc: AdsDetailViewController = assembler.resolve(navigationController: navigationController, relocation: relocation)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toSlider(_ product: Product, position: Int) {
        let vc: ImageSliderViewController = assembler.resolve(navigationController: navigationController, images: product.Images, position: position)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}

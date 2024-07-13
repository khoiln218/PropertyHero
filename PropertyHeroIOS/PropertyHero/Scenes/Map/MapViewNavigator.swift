//
//  MapViewNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol MapViewNavigatorType {
    func toProductDetail(_ productId: Int)
    func toProductList(_ searchInfo: SearchInfo, title: String)
    func toSearchByMarker()
    func toFilter() -> Driver<FilterChangedDelegate>
}

struct MapViewNavigator: MapViewNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toProductDetail(_ productId: Int) {
        let vc: ProductDetailViewController = assembler.resolve(navigationController: navigationController, productId: productId)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toProductList(_ searchInfo: SearchInfo, title: String) {
        let vc: ProductListViewController = assembler.resolve(navigationController: navigationController, searchInfo: searchInfo, title: title)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toSearchByMarker() {
        navigationController.popViewController(animated: false)
        
        let mainViewController: MainViewController? = navigationController.viewControllers.first(where:{ $0 is MainViewController}) as? MainViewController
        if mainViewController == nil { return }
        DispatchQueue.main.async {
            mainViewController!.tabLayout.setIndex(index: 1, animated: false, scroll: false)
            mainViewController!.viewModel.navigator.toTabMenu(mainViewController!, tab: .search)
        }
        
        let searchViewController: SearchViewController? = mainViewController!.children.first(where:{ $0 is SearchViewController}) as? SearchViewController
        if searchViewController == nil { return }
        DispatchQueue.main.async {
            searchViewController!.tabLayout.setIndex(index: 1, animated: false, scroll: false)
            searchViewController!.viewModel.navigator.toSearchMenu(searchViewController!, tab: .marker)
        }
    }
    
    func toFilter() -> Driver<FilterChangedDelegate> {
        let delegate = PublishSubject<FilterChangedDelegate>()
        let vc: FilterViewController = assembler.resolve(navigationController: navigationController, delegate: delegate)
        navigationController.pushViewController(vc, animated: true)
        
        return delegate.asDriverOnErrorJustComplete()
    }
}

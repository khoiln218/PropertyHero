//
//  CollectionNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit

protocol CollectionNavigatorType {
    func initCollection(_ target: CollectionViewController)
    func toCollectionMenu(_ target: CollectionViewController, tab: TabCollection)
}

struct CollectionNavigator: CollectionNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func initCollection(_ target: CollectionViewController) {
        let vcFavorite: FavoriteViewController = assembler.resolve(navigationController: navigationController)
        navigationController.addFragmentToCollection(target, vc: vcFavorite, tab: .favorite)
        
        let vcView: ProductViewViewController = assembler.resolve(navigationController: navigationController)
        navigationController.addFragmentToCollection(target, vc: vcView, tab: .view)
    }
    
    func toCollectionMenu(_ target: CollectionViewController, tab: TabCollection) {
        navigationController.showViewControllerInCollection(target, tab: tab)
    }
}

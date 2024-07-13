//
//  MainNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/5/23.
//

import UIKit

protocol MainNavigatorType {
    func initMain(_ target: MainViewController)
    func toTabMenu(_ target: MainViewController, tab: TabMenu)
    func toLogin()
}

struct MainNavigator: MainNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func initMain(_ target: MainViewController) {
        let vcMore: MoreViewController = assembler.resolve(navigationController: navigationController)
        navigationController.addFragmentToMain(target, vc: vcMore, tab: .more)
        
        let vcNotification: NotificationViewController = assembler.resolve(navigationController: navigationController)
        navigationController.addFragmentToMain(target, vc: vcNotification, tab: .notification)
        
        let vcCollection: CollectionViewController = assembler.resolve(navigationController: navigationController)
        navigationController.addFragmentToMain(target, vc: vcCollection, tab: .collection)
        
        let vcSearch: SearchViewController = assembler.resolve(navigationController: navigationController)
        navigationController.addFragmentToMain(target, vc: vcSearch, tab: .search)
        
        let vcHome: HomeViewController = assembler.resolve(navigationController: navigationController)
        navigationController.addFragmentToMain(target, vc: vcHome, tab: .home)
    }
    
    func toTabMenu(_ target: MainViewController, tab: TabMenu) {
        navigationController.showViewControllerInMain(target, tab: tab)
    }
    
    func toLogin() {
        let vc: LoginViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
}


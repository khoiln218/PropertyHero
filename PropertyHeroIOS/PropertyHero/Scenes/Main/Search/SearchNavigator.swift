//
//  SearchNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit

protocol SearchNavigatorType {
    func initSearch(_ target: SearchViewController)
    func toSearchMenu(_ target: SearchViewController, tab: TabSearch)
}

struct SearchNavigator: SearchNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func initSearch(_ target: SearchViewController) {
        let vcSearchByMarker: SearchByMarkerViewController = assembler.resolve(navigationController: navigationController, markerType: .all)
        navigationController.addFragmentToSearch(target, vc: vcSearchByMarker, tab: .marker)
        
        let vcSearchByLocation: SearchByLocationViewController = assembler.resolve(navigationController: navigationController)
        navigationController.addFragmentToSearch(target, vc: vcSearchByLocation, tab: .location)
    }
    
    func toSearchMenu(_ target: SearchViewController, tab: TabSearch) {
        navigationController.showViewControllerInSearch(target, tab: tab)
    }
}

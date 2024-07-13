//
//  HomeNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit
import GoogleMaps

protocol HomeNavigatorType {
    func toMapView(_ title: String, latlng: CLLocationCoordinate2D, type: PropertyType)
    func toProductList(_ searchInfo: SearchInfo, title: String)
    func toFindArea()
}

struct HomeNavigator: HomeNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toMapView(_ title: String, latlng: CLLocationCoordinate2D, type: PropertyType) {
        let vc: MapViewViewController = assembler.resolve(navigationController: navigationController, title: title, latlng: latlng, type: type)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toProductList(_ searchInfo: SearchInfo, title: String) {
        let vc: ProductListViewController = assembler.resolve(navigationController: navigationController, searchInfo: searchInfo, title: title)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toFindArea() {
        let vcSearchByMarker: SearchByMarkerViewController = assembler.resolve(navigationController: navigationController, markerType: .attr)
        navigationController.pushViewController(vcSearchByMarker, animated: true)
    }
}

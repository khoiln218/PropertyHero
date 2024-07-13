//
//  SearchByLocationNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/11/23.
//

import UIKit
import CoreLocation

protocol SearchByLocationNavigatorType {
    func toMapView(_ title: String, latlng: CLLocationCoordinate2D, type: PropertyType)
}

struct SearchByLocationNavigator: SearchByLocationNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toMapView(_ title: String, latlng: CLLocationCoordinate2D, type: PropertyType) {
        let vc: MapViewViewController = assembler.resolve(navigationController: navigationController, title: title, latlng: latlng, type: type)
        navigationController.pushViewController(vc, animated: true)
    }
}

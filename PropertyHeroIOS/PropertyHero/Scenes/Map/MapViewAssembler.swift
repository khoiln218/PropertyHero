//
//  MapViewAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit
import Reusable
import CoreLocation

protocol MapViewAssembler {
    func resolve(navigationController: UINavigationController, title: String, latlng: CLLocationCoordinate2D, type: PropertyType) -> MapViewViewController
    func resolve(navigationController: UINavigationController, title: String, latlng: CLLocationCoordinate2D, type: PropertyType) -> MapViewViewModel
    func resolve(navigationController: UINavigationController) -> MapViewNavigatorType
    func resolve() -> MapViewUseCaseType
}

extension MapViewAssembler {
    func resolve(navigationController: UINavigationController, title: String, latlng: CLLocationCoordinate2D, type: PropertyType) -> MapViewViewController {
        let vc = MapViewViewController.instantiate()
        let vm: MapViewViewModel = resolve(navigationController: navigationController, title: title, latlng: latlng, type: type)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, title: String, latlng: CLLocationCoordinate2D, type: PropertyType) -> MapViewViewModel {
        return MapViewViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            title: title,
            latlng: latlng,
            type: type
        )
    }
}

extension MapViewAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> MapViewNavigatorType {
        return MapViewNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> MapViewUseCaseType {
        return MapViewUseCase(productGateway: resolve())
    }
}

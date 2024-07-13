//
//  HomeUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import RxSwift
import CoreLocation

protocol HomeUseCaseType {
    func getBanner() -> Observable<[Banner]>
    func getMarkersByLocation(_ latlng: CLLocationCoordinate2D, numItems: Int) -> Observable<[Marker]>
    func getMarkersByUniversity(_ numItems: Int) -> Observable<[Marker]>
}

struct HomeUseCase: HomeUseCaseType, GetCategory, GetLocation {
    var categoryGateway: CategoryGatewayType
    var locationGateway: LocationGatewayType
    
    func getBanner() -> Observable<[Banner]> {
        return categoryGateway.getBanner()
    }
    
    func getMarkersByLocation(_ latlng: CLLocationCoordinate2D, numItems: Int) -> Observable<[Marker]> {
        return locationGateway.getMarkersByLocation(latlng, numItems: numItems)
    }
    
    func getMarkersByUniversity(_ numItems: Int) -> Observable<[Marker]> {
        return locationGateway.getMarkersByUniversity(numItems)
    }
}

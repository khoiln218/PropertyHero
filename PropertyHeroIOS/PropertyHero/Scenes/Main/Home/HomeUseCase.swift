//
//  HomeUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import RxSwift
import CoreLocation
import MGArchitecture

protocol HomeUseCaseType {
    func getBanner() -> Observable<[Banner]>
    func getMarkersByLocation(_ latlng: CLLocationCoordinate2D, numItems: Int) -> Observable<[Marker]>
    func getMarkersByUniversity(_ numItems: Int) -> Observable<[Marker]>
    func search(_ seachInfo: SearchInfo) -> Observable<PagingInfo<Product>>
}

struct HomeUseCase: HomeUseCaseType, GetCategory, GetLocation, GetProduct {
    var categoryGateway: CategoryGatewayType
    var locationGateway: LocationGatewayType
    var productGateway: ProductGatewayType
    
    func getBanner() -> Observable<[Banner]> {
        return categoryGateway.getBanner()
    }
    
    func getMarkersByLocation(_ latlng: CLLocationCoordinate2D, numItems: Int) -> Observable<[Marker]> {
        return locationGateway.getMarkersByLocation(latlng, numItems: numItems)
    }
    
    func getMarkersByUniversity(_ numItems: Int) -> Observable<[Marker]> {
        return locationGateway.getMarkersByUniversity(numItems)
    }
    
    func search(_ seachInfo: SearchInfo) -> Observable<PagingInfo<Product>> {
        return productGateway.search(seachInfo)
    }
}

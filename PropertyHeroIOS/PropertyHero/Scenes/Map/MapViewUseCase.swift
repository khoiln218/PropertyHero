//
//  MapViewUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import RxSwift

protocol MapViewUseCaseType {
    func search(_ seachInfo: SearchInfo) -> Observable<[Product]>
}

struct MapViewUseCase: MapViewUseCaseType, GetProduct {
    var productGateway: ProductGatewayType
    
    func search(_ seachInfo: SearchInfo) -> Observable<[Product]> {
        return productGateway.search(seachInfo)
            .map {
                $0.items
            }
    }
}

//
//  ProductListUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import RxSwift
import MGArchitecture

protocol ProductListUseCaseType {
    func search(_ seachInfo: SearchInfo) -> Observable<PagingInfo<Product>>
}

struct ProductListUseCase: ProductListUseCaseType, GetProduct {
    var productGateway: ProductGatewayType
    
    func search(_ seachInfo: SearchInfo) -> Observable<PagingInfo<Product>> {
        return productGateway.search(seachInfo)
    }
}

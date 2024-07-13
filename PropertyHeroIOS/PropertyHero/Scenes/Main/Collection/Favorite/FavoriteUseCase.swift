//
//  FavoriteUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import RxSwift

protocol FavoriteUseCaseType {
    func getFavorite(_ accountId: Int) -> Observable<[Product]>
}

struct FavoriteUseCase: FavoriteUseCaseType, GetProduct {
    var productGateway: ProductGatewayType
    
    func getFavorite(_ accountId: Int) -> Observable<[Product]> {
        getProductFavorite(accountId)
    }
}

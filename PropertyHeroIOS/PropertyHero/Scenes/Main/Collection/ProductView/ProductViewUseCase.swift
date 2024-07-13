//
//  ProductViewUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import RxSwift

protocol ProductViewUseCaseType {
    func getRecently(_ accountId: Int) -> Observable<[Product]>
}

struct ProductViewUseCase: ProductViewUseCaseType, GetProduct {
    var productGateway: ProductGatewayType
    
    func getRecently(_ accountId: Int) -> Observable<[Product]> {
        getProductRecently(accountId)
    }
}

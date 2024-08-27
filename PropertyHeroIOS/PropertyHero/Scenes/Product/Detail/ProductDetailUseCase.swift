//
//  ProductDetailUseCase.swift
//  Gomi Mall
//
//  Created by KHOI LE on 5/28/21.
//  Copyright © 2021 GomiCorp. All rights reserved.
//

import RxSwift

protocol ProductDetailUseCaseType {
    func productDetail(_ productId: Int, accountId: Int, isMeViewThis: Int) -> Observable<Product>
    func getPowerLink(_ provinceId: Int) -> Observable<[Relocation]>
    func favorite(_ productId: Int, accountId: Int) -> Observable<Bool>
    func deleteFavorite(_ productId: Int, accountId: Int) -> Observable<Bool>
    func translate(_ text: String) -> Observable<String>
}

struct ProductDetailUseCase: ProductDetailUseCaseType, GetProduct, GetCategory, Google {
    
    let productGateway: ProductGatewayType
    var categoryGateway: CategoryGatewayType
    var googleGateway: GoogleGatewayType
    
    func productDetail(_ productId: Int, accountId: Int, isMeViewThis: Int) -> Observable<Product> {
        return productGateway.detail(productId, accountId: accountId, isMeViewThis: isMeViewThis)
    }
    
    func getPowerLink(_ provinceId: Int) -> Observable<[Relocation]> {
        return categoryGateway.getPowerLink(provinceId)
    }
    
    func favorite(_ productId: Int, accountId: Int) -> Observable<Bool> {
        return productGateway.favorite(productId, accountId: accountId)
    }
    
    func deleteFavorite(_ productId: Int, accountId: Int) -> Observable<Bool> {
        return productGateway.favoriteDelete(productId, accountId: accountId)
    }
    func translate(_ text: String, targetLang: String, apiKey: String) -> Observable<String> {
        return googleGateway.translate(text)
    }
}

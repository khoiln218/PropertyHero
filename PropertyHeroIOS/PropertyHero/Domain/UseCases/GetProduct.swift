//
//  GetProduct.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/10/23.
//

import RxSwift
import MGArchitecture

protocol GetProduct {
    var productGateway: ProductGatewayType { get }
}

extension GetProduct {
    func search(_ searchInfo: SearchInfo) -> Observable<PagingInfo<Product>> {
        return productGateway.search(searchInfo)
    }
    
    func detail(_ productId: Int, accountId: Int, isMeViewThis: Int) -> Observable<Product> {
        return productGateway.detail(productId, accountId: accountId, isMeViewThis: isMeViewThis)
    }
    
    func getProductFavorite(_ accountId: Int) -> Observable<[Product]> {
        return productGateway.getFavorite(accountId)
            .map { favorites -> [Product] in
                favorites.map {
                    Product(Id: $0.ProductID, Address: $0.Address, Images: $0.Avatar, Price: $0.Price, GrossFloorArea: $0.GrossFloorArea, Title: $0.Title)
                }
            }
    }
    
    func getProductRecently(_ accountId: Int) -> Observable<[Product]> {
        return productGateway.getRecently(accountId)
            .map { favorites -> [Product] in
                favorites.map {
                    Product(Id: $0.ProductID, Address: $0.Address, Images: $0.Avatar, Price: $0.Price, GrossFloorArea: $0.GrossFloorArea, Title: $0.Title)
                }
            }
    }
    
    func favorite(_ productId: Int, accountId: Int) -> Observable<Bool> {
        return productGateway.favorite(productId, accountId: accountId)
    }
    
    func deleteFavorite(_ productId: Int, accountId: Int) -> Observable<Bool> {
        return productGateway.favoriteDelete(productId, accountId: accountId)
    }
}

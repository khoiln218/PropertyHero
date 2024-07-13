//
//  ProductGateway.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/10/23.
//

import UIKit
import RxSwift
import MGArchitecture

protocol ProductGatewayType {
    func search(_ seachInfo: SearchInfo) -> Observable<PagingInfo<Product>>
    func detail(_ productId: Int, accountId: Int, isMeViewThis: Int) -> Observable<Product>
    func getFavorite(_ accountId: Int) -> Observable<[Favorite]>
    func getRecently(_ accountId: Int) -> Observable<[Favorite]>
    func favorite(_ productId: Int, accountId: Int) -> Observable<Bool>
    func favoriteDelete(_ productId: Int, accountId: Int) -> Observable<Bool>
}

struct ProductGateway: ProductGatewayType {
    
    func search(_ seachInfo: SearchInfo) -> Observable<PagingInfo<Product>> {
        let input = API.ProductSearchInput(seachInfo)
        
        return API.shared.productSearch(input)
            .map { $0.products }
            .unwrap()
            .map { PagingInfo(page: seachInfo.pageNo, items: $0) }
    }
    
    func detail(_ productId: Int, accountId: Int, isMeViewThis: Int) -> Observable<Product> {
        let input = API.ProductDetailInput(productId, accountId: accountId, isMeViewThis: isMeViewThis)
        
        return API.shared.productDetail(input)
            .map { $0.products }
            .unwrap()
            .map { $0.count > 0 ? $0[0] : Product() }
    }
    
    func getFavorite(_ accountId: Int) -> Observable<[Favorite]> {
        let input = API.GetFavoriteInput(accountId)
        
        return API.shared.getFavorite(input)
            .map { $0.favorites }
            .unwrap()
    }
    
    func getRecently(_ accountId: Int) -> Observable<[Favorite]> {
        let input = API.GetRecentlyInput(accountId)
        
        return API.shared.getRecently(input)
            .map { $0.favorites }
            .unwrap()
    }
    
    func favorite(_ productId: Int, accountId: Int) -> Observable<Bool> {
        let input = API.FavoriteInput(productId, accountId: accountId)
        
        return API.shared.favorite(input)
            .map { $0.isSuccessful }
            .unwrap()
    }
    
    func favoriteDelete(_ productId: Int, accountId: Int) -> Observable<Bool> {
        let input = API.FavoriteDeleteInput(productId, accountId: accountId)
        
        return API.shared.deleteFavorite(input)
            .map { $0.isSuccessful }
            .unwrap()
    }
}

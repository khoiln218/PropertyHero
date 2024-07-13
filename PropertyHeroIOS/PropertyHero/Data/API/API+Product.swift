//
//  API+Product.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/10/23.
//

import ObjectMapper
import RxSwift
import MGAPIService

extension API {
    func productSearch(_ input: ProductSearchInput) -> Observable<ProductSearchOutput> {
        return request(input)
    }
    
    func productDetail(_ input: ProductDetailInput) -> Observable<ProductDetailOutput> {
        return request(input)
    }
    
    func getFavorite(_ input: GetFavoriteInput) -> Observable<GetFavoriteOutput> {
        return request(input)
    }
    
    func favorite(_ input: FavoriteInput) -> Observable<FavoriteOutput> {
        return request(input)
    }
    
    func deleteFavorite(_ input: FavoriteDeleteInput) -> Observable<FavoriteOutput> {
        return request(input)
    }
    
    func getRecently(_ input: GetRecentlyInput) -> Observable<GetRecentlyOutput> {
        return request(input)
    }
}

extension API {
    final class FavoriteDeleteInput: APIUploadInputBase {
        init(_ productId: Int, accountId: Int) {
            let params: JSONDictionary = [
                "ProductID": productId,
                "AccountID": accountId
            ]
            super.init(data: [], urlString: API.Urls.deleteFavorite,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class FavoriteInput: APIUploadInputBase {
        init(_ productId: Int, accountId: Int) {
            let params: JSONDictionary = [
                "ProductID": productId,
                "AccountID": accountId
            ]
            super.init(data: [], urlString: API.Urls.favorite,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class FavoriteOutput: APIOutput {
        private(set) var isSuccessful: Bool?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            isSuccessful <- map["DataList"]
        }
    }
    
    final class GetRecentlyInput: APIUploadInputBase {
        init(_ accountId: Int) {
            let params: JSONDictionary = [
                "AccountID": accountId
            ]
            super.init(data: [], urlString: API.Urls.getRecently,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class GetRecentlyOutput: APIOutput {
        private(set) var favorites: [Favorite]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            favorites <- map["DataList"]
        }
    }
    
    final class GetFavoriteInput: APIUploadInputBase {
        init(_ accountId: Int) {
            let params: JSONDictionary = [
                "AccountID": accountId
            ]
            super.init(data: [], urlString: API.Urls.getFavorite,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class GetFavoriteOutput: APIOutput {
        private(set) var favorites: [Favorite]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            favorites <- map["DataList"]
        }
    }
    
    final class ProductDetailInput: APIUploadInputBase {
        init(_ productId: Int, accountId: Int, isMeViewThis: Int) {
            let params: JSONDictionary = [
                "ProductID": productId,
                "AccountID": accountId,
                "IsMeViewThis": isMeViewThis,
                "LanguageType": 0
            ]
            super.init(data: [], urlString: API.Urls.productDetail,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class ProductDetailOutput: APIOutput {
        private(set) var products: [Product]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            products <- map["DataList"]
        }
    }
    
    final class ProductSearchInput: APIUploadInputBase {
        init(_ searchInfo: SearchInfo) {
            let params: JSONDictionary = [
                "StartLat": searchInfo.startLat,
                "StartLng": searchInfo.startLng,
                "EndLat": searchInfo.endLat,
                "EndLng": searchInfo.endLng,
                "Distance": searchInfo.distance,
                "PropertyType": searchInfo.propertyType,
                "PropertyID": searchInfo.propertyID,
                "MinPrice": searchInfo.minPrice,
                "MaxPrice": searchInfo.maxPrice,
                "MinArea": searchInfo.minArea,
                "MaxArea": searchInfo.maxArea,
                "Bedroom": searchInfo.bed,
                "Bathroom": searchInfo.bath,
                "Status": searchInfo.status,
                "PageNo": searchInfo.pageNo,
                "LanguageType": 0,
            ]
            super.init(data: [], urlString: API.Urls.productSearch,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class ProductSearchOutput: APIOutput {
        private(set) var products: [Product]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            products <- map["DataList"]
        }
    }
}

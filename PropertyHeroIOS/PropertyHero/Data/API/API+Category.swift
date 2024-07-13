//
//  API+Category.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import ObjectMapper
import RxSwift
import MGAPIService

extension API {
    func getBanner(_ input: GetBannerListInput) -> Observable<GetBannerListOutput> {
        return request(input)
    }
    
    func getPowerLink(_ input: GetPowerLinkInput) -> Observable<GetPowerLinkOutput> {
        return request(input)
    }
    
    func sendWarning(_ input: SendWarningInput) -> Observable<SendWarningOutput> {
        return request(input)
    }
    
    func getListProperty(_ input: ListPropertyInput) -> Observable<ListPropertyOutput> {
        return request(input)
    }
}

extension API {
    final class ListPropertyInput: APIInput {
        init() {
            super.init(urlString: API.Urls.listProperty,
                       parameters: nil,
                       method: .get,
                       requireAccessToken: true)
        }
    }
    
    final class ListPropertyOutput: APIOutput {
        private(set) var option: Option?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            option <- map["DataList"]
        }
    }
    
    final class SendWarningInput: APIUploadInputBase {
        init(_ productId: Int, accountId: Int, warningType: Int, content: String) {
            let params: JSONDictionary = [
                "ProductID": productId,
                "AccountID": accountId,
                "WarningType": warningType,
                "Content": content
            ]
            super.init(data: [], urlString: API.Urls.sendWarning,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class SendWarningOutput: APIOutput {
        private(set) var isSuccessful: Bool?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            isSuccessful <- map["DataList"]
        }
    }
    
    final class GetPowerLinkInput: APIInput {
        init(_ provinceId: Int) {
            let urlString = String(format: API.Urls.powerLink, provinceId)
            super.init(urlString: urlString,
                       parameters: nil,
                       method: .get,
                       requireAccessToken: true)
        }
    }
    
    final class GetPowerLinkOutput: APIOutput {
        private(set) var relocations: [Relocation]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            relocations <- map["DataList"]
        }
    }
    
    final class GetBannerListInput: APIInput {
        init() {
            super.init(urlString: API.Urls.getBanner,
                       parameters: nil,
                       method: .get,
                       requireAccessToken: true)
        }
    }
    
    final class GetBannerListOutput: APIOutput {
        private(set) var banners: [Banner]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            banners <- map["DataList"]
        }
    }
}

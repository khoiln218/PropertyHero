//
//  API+Location.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/12/23.
//

import ObjectMapper
import RxSwift
import MGAPIService
import CoreLocation

extension API {
    func getProvince(_ input: GetProvinceListInput) -> Observable<GetProvinceListOutput> {
        return request(input)
    }
    
    func getDistrict(_ input: GetDistrictListInput) -> Observable<GetDistrictListOutput> {
        return request(input)
    }
    
    func searchMarkers(_ input: SearchMarkerInput) -> Observable<SearchMarkerOutput> {
        return request(input)
    }
    
    func getMarkersByLocation(_ input: GetMarkersByLocationInput) -> Observable<GetMarkersByLocationOutput> {
        return request(input)
    }
    
    func getMarkersByUniversity(_ input: GetMarkersByUniversityInput) -> Observable<GetMarkersByUniversityOutput> {
        return request(input)
    }
}

extension API {
    
    final class GetMarkersByUniversityInput: APIInput {
        init(_ numItems: Int) {
            let urlString = String(format: API.Urls.markerByUniversity, numItems, 0)
            super.init(urlString: urlString,
                       parameters: nil,
                       method: .get,
                       requireAccessToken: true)
        }
    }
    
    final class GetMarkersByUniversityOutput: APIOutput {
        private(set) var markers: [Marker]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            markers <- map["DataList"]
        }
    }
    
    final class GetMarkersByLocationInput: APIInput {
        init(_ latlng: CLLocationCoordinate2D, numItems: Int) {
            let urlString = String(format: API.Urls.markerByLocation, latlng.latitude, latlng.longitude, numItems, 0)
            super.init(urlString: urlString,
                       parameters: nil,
                       method: .get,
                       requireAccessToken: true)
        }
    }
    
    final class GetMarkersByLocationOutput: APIOutput {
        private(set) var markers: [Marker]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            markers <- map["DataList"]
        }
    }
    
    final class GetDistrictListInput: APIInput {
        init(_ provinceId: Int) {
            let urlString = String(format: API.Urls.listDistrict, provinceId)
            super.init(urlString: urlString,
                       parameters: nil,
                       method: .get,
                       requireAccessToken: true)
        }
    }
    
    final class GetDistrictListOutput: APIOutput {
        private(set) var districts: [District]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            districts <- map["DataList"]
        }
    }
    
    final class GetProvinceListInput: APIInput {
        init() {
            let urlString = String(format: API.Urls.listProvince, CountryId.vietnam.rawValue)
            super.init(urlString: urlString,
                       parameters: nil,
                       method: .get,
                       requireAccessToken: true)
        }
    }
    
    final class GetProvinceListOutput: APIOutput {
        private(set) var provinces: [Province]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            provinces <- map["DataList"]
        }
    }
    
    final class SearchMarkerInput: APIUploadInputBase {
        init(_ keyword: String, provinceID: Int, markerType: Int) {
            let params: JSONDictionary = [
                "Keyword": keyword,
                "ProvinceID": provinceID,
                "MarkerType": markerType,
                "LanguageType": 0,
            ]
            super.init(data: [], urlString: API.Urls.markerByKeywords,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class SearchMarkerOutput: APIOutput {
        private(set) var markers: [Marker]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            markers <- map["DataList"]
        }
    }
}

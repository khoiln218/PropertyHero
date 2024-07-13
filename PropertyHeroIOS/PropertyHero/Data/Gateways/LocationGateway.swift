//
//  LocationGateway.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/12/23.
//

import UIKit
import RxSwift
import MGArchitecture
import CoreLocation

protocol LocationGatewayType {
    func getProvinces() -> Observable<[Province]>
    
    func getDistricts(_ provinceId: Int) -> Observable<[District]>
    
    func searchMarkers(_ keyword: String, provinceID: Int, markerType: Int) -> Observable<[Marker]>
    
    func getMarkersByLocation(_ latlng: CLLocationCoordinate2D, numItems: Int) -> Observable<[Marker]>
    
    func getMarkersByUniversity(_ numItems: Int) -> Observable<[Marker]>
}

struct LocationGateway: LocationGatewayType {
    
    func getProvinces() -> Observable<[Province]> {
        let input = API.GetProvinceListInput()
        
        return API.shared.getProvince(input)
            .map { $0.provinces }
            .unwrap()
    }
    
    func getDistricts(_ provinceId: Int) -> Observable<[District]> {
        let input = API.GetDistrictListInput(provinceId)
        
        return API.shared.getDistrict(input)
            .map { $0.districts }
            .unwrap()
    }
    
    func searchMarkers(_ keyword: String, provinceID: Int, markerType: Int) -> Observable<[Marker]> {
        let input = API.SearchMarkerInput(keyword, provinceID: provinceID, markerType: markerType)
        
        return API.shared.searchMarkers(input)
            .map { $0.markers }
            .unwrap()
    }
    
    func getMarkersByLocation(_ latlng: CLLocationCoordinate2D, numItems: Int) -> Observable<[Marker]>{
        let input = API.GetMarkersByLocationInput(latlng, numItems: numItems)
        
        return API.shared.getMarkersByLocation(input)
            .map { $0.markers }
            .unwrap()
    }
    
    func getMarkersByUniversity(_ numItems: Int) -> Observable<[Marker]>{
        let input = API.GetMarkersByUniversityInput(numItems)
        
        return API.shared.getMarkersByUniversity(input)
            .map { $0.markers }
            .unwrap()
    }
}

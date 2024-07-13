//
//  GetLocation.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/12/23.
//

import RxSwift
import MGArchitecture
import CoreLocation

protocol GetLocation {
    var locationGateway: LocationGatewayType { get }
}

extension GetLocation {
    func getProvinces() -> Observable<[Province]> {
        return locationGateway.getProvinces()
    }
    
    func getDistricts(_ provinceId: Int) -> Observable<[District]> {
        return locationGateway.getDistricts(provinceId)
    }
    
    func searchMarkers(_ keyword: String, provinceID: Int, markerType: Int) -> Observable<[Marker]> {
        return locationGateway.searchMarkers(keyword, provinceID: provinceID, markerType: markerType)
    }
    
    func getMarkersByLocation(_ latlng: CLLocationCoordinate2D, numItems: Int) -> Observable<[Marker]> {
        return locationGateway.getMarkersByLocation(latlng, numItems: numItems)
    }
    
    func getMarkersByUniversity(_ numItems: Int) -> Observable<[Marker]> {
        return locationGateway.getMarkersByUniversity(numItems)
    }
}

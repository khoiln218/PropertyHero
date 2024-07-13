//
//  SearchByMarkerUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/11/23.
//

import RxSwift

protocol SearchByMarkerUseCaseType {
    func getProvinces() -> Observable<[Province]>
    
    func searchMarkers(_ keyword: String, provinceID: Int, markerType: Int) -> Observable<[Marker]>
}

struct SearchByMarkerUseCase: SearchByMarkerUseCaseType, GetLocation {
    var locationGateway: LocationGatewayType
    
    func getProvinces() -> Observable<[Province]> {
        return locationGateway.getProvinces()
    }
    
    func searchMarkers(_ keyword: String, provinceID: Int, markerType: Int) -> Observable<[Marker]> {
        return locationGateway.searchMarkers(keyword, provinceID: provinceID, markerType: markerType)
    }
}

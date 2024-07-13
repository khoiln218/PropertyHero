//
//  SearchByLocationUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/11/23.
//

import RxSwift

protocol SearchByLocationUseCaseType {
    func getProvinces() -> Observable<[Province]>
    func getDistricts(_ provinceId: Int) -> Observable<[District]>
}

struct SearchByLocationUseCase: SearchByLocationUseCaseType , GetLocation {
    var locationGateway: LocationGatewayType
    
    func getProvinces() -> Observable<[Province]> {
        return locationGateway.getProvinces()
    }
    
    func getDistricts(_ provinceId: Int) -> Observable<[District]> {
        return locationGateway.getDistricts(provinceId)
    }
}

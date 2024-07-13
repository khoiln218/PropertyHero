//
//  SettingUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/2/23.
//

import RxSwift

protocol SettingUseCaseType {
    func getProvinces() -> Observable<[Province]>
}

struct SettingUseCase: SettingUseCaseType , GetLocation {
    var locationGateway: LocationGatewayType
    
    func getProvinces() -> Observable<[Province]> {
        return locationGateway.getProvinces()
    }
}

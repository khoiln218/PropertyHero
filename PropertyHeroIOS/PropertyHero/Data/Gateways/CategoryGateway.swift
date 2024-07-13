//
//  CategoryGateway.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit
import RxSwift
import MGArchitecture

protocol CategoryGatewayType {
    func getBanner() -> Observable<[Banner]>
    func getPowerLink(_ provinceId: Int) -> Observable<[Relocation]>
    func sendWarning(_ productId: Int, accountId: Int, warningType: Int, content: String) -> Observable<Bool>
    func getListProperty() -> Observable<[PropertyId]>
}

struct CategoryGateway: CategoryGatewayType {
    
    func getBanner() -> Observable<[Banner]> {
        let input = API.GetBannerListInput()
        
        return API.shared.getBanner(input)
            .map { $0.banners }
            .unwrap()
    }
    
    func getPowerLink(_ provinceId: Int) -> Observable<[Relocation]> {
        let input = API.GetPowerLinkInput(provinceId)
        
        return API.shared.getPowerLink(input)
            .map { $0.relocations }
            .unwrap()
    }
    
    func sendWarning(_ productId: Int, accountId: Int, warningType: Int, content: String) -> Observable<Bool> {
        let input = API.SendWarningInput(productId, accountId: accountId, warningType: warningType, content: content)
        
        return API.shared.sendWarning(input)
            .map { $0.isSuccessful }
            .unwrap()
    }
    
    func getListProperty() -> Observable<[PropertyId]> {
        let input = API.ListPropertyInput()
        
        return API.shared.getListProperty(input)
            .map { $0.option }
            .unwrap()
            .map { $0.peoperties }
            .unwrap()
    }
}

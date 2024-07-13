//
//  GetCategory.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import RxSwift
import MGArchitecture

protocol GetCategory {
    var categoryGateway: CategoryGatewayType { get }
}

extension GetCategory {
    func getBanner() -> Observable<[Banner]> {
        return categoryGateway.getBanner()
    }
    
    func getPowerLink(_ provinceId: Int) -> Observable<[Relocation]> {
        return categoryGateway.getPowerLink(provinceId)
    }
    
    func sendWarning(_ productId: Int, accountId: Int, warningType: Int, content: String) -> Observable<Bool> {
        return categoryGateway.sendWarning(productId, accountId: accountId, warningType: warningType, content: content)
    }
    
    func getListProperty() -> Observable<[PropertyId]> {
        return categoryGateway.getListProperty()
    }
}

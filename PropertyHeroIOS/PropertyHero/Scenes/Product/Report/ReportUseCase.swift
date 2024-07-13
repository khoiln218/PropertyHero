//
//  ReportUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/24/23.
//

import RxSwift

protocol ReportUseCaseType {
    func sendReport(_ productId: Int, accountId: Int, type: Int, content: String) -> Observable<Bool>
}

struct ReportUseCase: ReportUseCaseType, GetCategory {
    var categoryGateway: CategoryGatewayType
    
    func sendReport(_ productId: Int, accountId: Int, type: Int, content: String) -> Observable<Bool> {
        categoryGateway.sendWarning(productId, accountId: accountId, warningType: type, content: content)
    }
}

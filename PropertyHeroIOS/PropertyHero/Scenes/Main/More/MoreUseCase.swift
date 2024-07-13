//
//  MoreUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import RxSwift

protocol MoreUseCaseType {
    func accountInfo(_ accountId: Int) -> Observable<[Account]>
}

struct MoreUseCase: MoreUseCaseType, Login {
    var loginGateway: LoginGatewayType
    
    func accountInfo(_ accountId: Int) -> Observable<[Account]> {
        loginGateway.getInfo(accountId)
    }
}

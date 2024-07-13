//
//  LoginUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/4/23.
//

import RxSwift

protocol LoginUseCaseType {
    func socialLogin(_ account: Account) -> Observable<[Account]>
}

struct LoginUseCase: LoginUseCaseType, Login {
    var loginGateway: LoginGatewayType
    
    func socialLogin(_ account: Account) -> Observable<[Account]> {
        loginGateway.socialLogin(account)
    }
}

//
//  ProfileUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/26/23.
//

import RxSwift
import MGAPIService

protocol ProfileUseCaseType {
    func changeAvatar(_ accountId: Int, username: String, avatar: APIUploadData) -> Observable<Bool>
}

struct ProfileUseCase: ProfileUseCaseType, Login {
    var loginGateway: LoginGatewayType
    
    func changeAvatar(_ accountId: Int, username: String, avatar: APIUploadData) -> Observable<Bool> {
        loginGateway.changeAvatar(accountId, username: username, avatar: avatar)
    }
}

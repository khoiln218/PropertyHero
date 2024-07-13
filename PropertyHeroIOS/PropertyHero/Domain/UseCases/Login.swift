//
//  Login.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/20/23.
//

import RxSwift
import MGArchitecture
import MGAPIService

protocol Login {
    var loginGateway: LoginGatewayType { get }
}

extension Login {
    func updateInfo(_ account: Account) -> Observable<Bool> {
        loginGateway.updateInfo(account)
    }
    
    func getInfo(_ accountId: Int) -> Observable<[Account]> {
        loginGateway.getInfo(accountId)
    }
    
    func socialLogin(_ account: Account) -> Observable<[Account]> {
        loginGateway.socialLogin(account)
    }
    
    func login(_ username: String, password: String) -> Observable<[Account]> {
        loginGateway.login(username, password: password)
    }
    
    func verify(_ username: String) -> Observable<[Account]> {
        loginGateway.verify(username)
    }
    
    func register(_ username: String, password: String, fullname: String, phoneNumber: String) -> Observable<Bool> {
        loginGateway.register(username, password: password, fullname: fullname, phoneNumber: phoneNumber)
    }
    
    func changePassword(_ accountId: Int, password: String) -> Observable<Bool> {
        loginGateway.changePassword(accountId, password: password)
    }
    
    func changeAvatar(_ accountId: Int, username: String, avatar: APIUploadData) -> Observable<Bool> {
        loginGateway.changeAvatar(accountId, username: username, avatar: avatar)
    }
    
    func accountDeletion(_ username: String, password: String) -> Observable<Bool> {
        loginGateway.accountDeletion(username, password: password)
    }
}

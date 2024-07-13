//
//  LoginGateway.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/20/23.
//

import UIKit
import RxSwift
import MGArchitecture
import MGAPIService

protocol LoginGatewayType {
    func updateInfo(_ account: Account) -> Observable<Bool>
    func getInfo(_ accountId: Int) -> Observable<[Account]>
    func socialLogin(_ account: Account) -> Observable<[Account]>
    func login(_ username: String, password: String) -> Observable<[Account]>
    func verify(_ username: String) -> Observable<[Account]>
    func register(_ username: String, password: String, fullname: String, phoneNumber: String) -> Observable<Bool>
    func changePassword(_ accountId: Int, password: String) -> Observable<Bool>
    func changeAvatar(_ accountId: Int, username: String, avatar: APIUploadData) -> Observable<Bool>
    func accountDeletion(_ username: String, password: String) -> Observable<Bool>
}

struct LoginGateway: LoginGatewayType {
    func updateInfo(_ account: Account) -> Observable<Bool> {
        let input = API.UpdateInfoInput(account)
        
        return API.shared.updateInfo(input)
            .map { $0.success }
            .unwrap()
    }
    
    func getInfo(_ accountId: Int) -> Observable<[Account]> {
        let input = API.GetInfoInput(accountId)
        
        return API.shared.getInfo(input)
            .map { $0.accounts }
            .unwrap()
    }
    
    func socialLogin(_ account: Account) -> Observable<[Account]> {
        let input = API.SocialLoginInput(account)
        
        return API.shared.socialLogin(input)
            .map { $0.accounts }
            .unwrap()
    }
    
    func login(_ username: String, password: String) -> Observable<[Account]> {
        let input = API.LoginInput(username, password: password)
        
        return API.shared.login(input)
            .map { $0.accounts }
            .unwrap()
    }
    
    func verify(_ username: String) -> Observable<[Account]>{
        let input = API.VerifyInput(username)
        
        return API.shared.verify(input)
            .map { $0.accounts }
            .unwrap()
    }
    
    func register(_ username: String, password: String, fullname: String, phoneNumber: String) -> Observable<Bool> {
        let input = API.RegisterInput(username, password: password, fullname: fullname, phoneNumber: phoneNumber)
        
        return API.shared.register(input)
            .map { $0.success }
            .unwrap()
    }
    
    func changePassword(_ accountId: Int, password: String) -> Observable<Bool> {
        let input = API.ChangePasswordInput(accountId, password: password)
        
        return API.shared.changePassword(input)
            .map { $0.success }
            .unwrap()
    }
    
    func changeAvatar(_ accountId: Int, username: String, avatar: APIUploadData) -> Observable<Bool> {
        let input = API.ChangeAvatarInput(accountId, username: username, avatar: avatar)
        
        return API.shared.changeAvatar(input)
            .map { $0.success }
            .unwrap()
    }
    
    func accountDeletion(_ username: String, password: String) -> Observable<Bool> {
        let input = API.AccountDeletionInput(username, password: password)
        
        return API.shared.accountDeletion(input)
            .map { $0.success }
            .unwrap()
    }
}

//
//  API+Auth.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/20/23.
//

import ObjectMapper
import RxSwift
import MGAPIService

extension API {
    
    func socialLogin(_ input: SocialLoginInput) -> Observable<SocialLoginOutput> {
        return request(input)
    }
    
    func login(_ input: LoginInput) -> Observable<LoginOutput> {
        return request(input)
    }
    
    func verify(_ input: VerifyInput) -> Observable<LoginOutput> {
        return request(input)
    }
    
    func register(_ input: RegisterInput) -> Observable<RegisterOutput> {
        return request(input)
    }
    
    func changePassword(_ input: ChangePasswordInput) -> Observable<ChangePasswordOutput> {
        return request(input)
    }
    
    func changeAvatar(_ input: ChangeAvatarInput) -> Observable<ChangeAvatarOutput> {
        return request(input)
    }
    
    func getInfo(_ input: GetInfoInput) -> Observable<GetInfoOutput> {
        return request(input)
    }
    
    func updateInfo(_ input: UpdateInfoInput) -> Observable<UpdateInfoOutput> {
        return request(input)
    }
    
    func accountDeletion(_ input: AccountDeletionInput) -> Observable<AccountDeletionOutput> {
        return request(input)
    }
}

extension API {
    final class SocialLoginInput: APIUploadInputBase {
        init(_ account: Account) {
            let params: JSONDictionary = [
                "UserName": account.UserName,
                "FullName": account.FullName,
                "Email": account.Email,
                "BirthDate": "",
                "Gender": "0",
                "AccountType": account.AccountType,
                "Token": "",
                "DeviceType": "",
                "Version": "",
                "Address": "",
                "Latitude": "",
                "Longitude": ""
            ]
            super.init(data: [], urlString: API.Urls.socialLogin,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class SocialLoginOutput: APIOutput {
        private(set) var accounts: [Account]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            accounts <- map["DataList"]
        }
    }
    
    final class AccountDeletionInput: APIUploadInputBase {
        init(_ username: String, password: String) {
            let params: JSONDictionary = [
                "UserName": username,
                "Password": password
            ]
            super.init(data: [], urlString: API.Urls.accountDeletion,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class AccountDeletionOutput: APIOutput {
        private(set) var success: Bool?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            success <- map["DataList"]
        }
    }
    
    final class UpdateInfoInput: APIUploadInputBase {
        init(_ account: Account) {
            let params: JSONDictionary = [
                "AccountID": account.Id,
                "FullName": account.FullName,
                "Gender": account.Gender,
                "BirthDate": account.BirthDate,
                "PhoneNumber": account.PhoneNumber,
                "Email": account.Email,
                "Address": account.Address,
                "CountryID": account.CountryID,
                "ProvinceID": account.ProvinceID,
                "DistrictID": account.DistrictID,
                "IDCode": account.IDCode,
                "IssuedDate": account.IssuedDate,
                "IssuedPlace": account.IssuedPlace
            ]
            super.init(data: [], urlString: API.Urls.updateInfo,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class UpdateInfoOutput: APIOutput {
        private(set) var success: Bool?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            success <- map["DataList"]
        }
    }
    
    final class GetInfoInput: APIInput {
        init(_ accountId: Int) {
            let urlString = String(format: API.Urls.getDetail, accountId)
            super.init(urlString: urlString,
                       parameters: nil,
                       method: .get,
                       requireAccessToken: true)
        }
    }
    
    final class GetInfoOutput: APIOutput {
        private(set) var accounts: [Account]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            accounts <- map["DataList"]
        }
    }
    
    final class ChangeAvatarInput: APIUploadInputBase {
        init(_ accountId: Int, username: String, avatar: APIUploadData) {
            let params: JSONDictionary = [
                "AccountID": accountId,
                "UserName": username,
            ]
            super.init(data: [avatar], urlString: API.Urls.changeAvatar,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class ChangeAvatarOutput: APIOutput {
        private(set) var success: Bool?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            success <- map["DataList"]
        }
    }
    
    final class ChangePasswordInput: APIInput {
        init(_ accountId: Int, password: String) {
            let urlString = String(format: API.Urls.changePW, accountId, password)
            super.init(urlString: urlString,
                       parameters: nil,
                       method: .get,
                       requireAccessToken: true)
        }
    }
    
    final class ChangePasswordOutput: APIOutput {
        private(set) var success: Bool?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            success <- map["DataList"]
        }
    }
    
    final class RegisterInput: APIUploadInputBase {
        init(_ username: String, password: String, fullname: String, phoneNumber: String) {
            let params: JSONDictionary = [
                "UserName": username,
                "Password": password,
                "FullName": fullname,
                "PhoneNumber": phoneNumber
            ]
            super.init(data: [], urlString: API.Urls.register,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class RegisterOutput: APIOutput {
        private(set) var success: Bool?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            success <- map["DataList"]
        }
    }
    
    final class VerifyInput: APIInput {
        init(_ username: String) {
            let urlString = String(format: API.Urls.verify, username)
            super.init( urlString: urlString,
                        parameters: nil,
                        method: .get,
                        requireAccessToken: true)
        }
    }
    
    final class LoginInput: APIUploadInputBase {
        init(_ username: String, password: String) {
            let params: JSONDictionary = [
                "UserName": username,
                "Password": password,
                "Token": "",
                "DeviceType": "",
                "Version": "",
                "Address": "",
                "Latitude": "",
                "Longitude": ""
            ]
            super.init(data: [], urlString: API.Urls.login,
                       parameters: params,
                       method: .post,
                       requireAccessToken: true)
        }
    }
    
    final class LoginOutput: APIOutput {
        private(set) var accounts: [Account]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            accounts <- map["DataList"]
        }
    }
}

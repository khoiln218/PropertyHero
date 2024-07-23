//
//  AccountInfoUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/31/23.
//

import RxSwift
import Dto
import ValidatedPropertyKit
import MGAPIService

protocol AccountInfoUseCaseType {
    func changeAvatar(_ accountId: Int, username: String, avatar: APIUploadData) -> Observable<Bool>
    func accountInfo(_ accountId: Int) -> Observable<Account>
    func updateInfo(_ account: Account) -> Observable<Bool>
    func getProvinces() -> Observable<[Province]>
    func getDistricts(_ provinceId: Int) -> Observable<[District]>
    func validateFullname(_ fullname: String) -> ValidationResult
    func validatePhoneNumber(_ phoneNumber: String) -> ValidationResult
}

struct AccountInfoUseCase: AccountInfoUseCaseType, GetLocation, Login {
    var locationGateway: LocationGatewayType
    var loginGateway: LoginGatewayType
    
    func changeAvatar(_ accountId: Int, username: String, avatar: APIUploadData) -> Observable<Bool> {
        loginGateway.changeAvatar(accountId, username: username, avatar: avatar)
    }
    
    func accountInfo(_ accountId: Int) -> Observable<Account> {
        loginGateway.getInfo(accountId)
            .map { $0[0] }
            .unwrap()
    }
    
    func updateInfo(_ account: Account) -> Observable<Bool> {
        return loginGateway.updateInfo(account)
    }
    
    func getProvinces() -> Observable<[Province]> {
        return locationGateway.getProvinces()
    }
    
    func getDistricts(_ provinceId: Int) -> Observable<[District]> {
        return locationGateway.getDistricts(provinceId)
    }
    
    func validateFullname(_ fullname: String) -> ValidationResult {
        if fullname.isEmpty {
            return .failure(ValidationError(message: "Vui lòng nhập họ và tên"))
        } else {
            return .success(())
        }
    }
    
    func validatePhoneNumber(_ phoneNumber: String) -> ValidationResult {
        if phoneNumber.isEmpty {
            return .failure(ValidationError(message: "Vui lòng nhập số điện thoại"))
        } else if isValidPhoneNumber(phone: phoneNumber) {
            return .success(())
        } else {
            return .failure(ValidationError(message: "Số điện thoại không đúng định dạng (03xxxxxxxx, 05xxxxxxxx, 07xxxxxxxx, 08xxxxxxxx, 09xxxxxxxx)"))
        }
    }
    
    func isValidPhoneNumber(phone: String) -> Bool {
        let phoneRegEx = "^(\\+84|0)[35789][0-9]{8}$"
        
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }
}

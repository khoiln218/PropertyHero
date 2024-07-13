//
//  ChangePasswordUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/29/23.
//

import RxSwift
import Dto
import ValidatedPropertyKit

protocol ChangePasswordUseCaseType {
    func changePassword(_ accountID: Int, password: String) -> Observable<Bool>
    func validateOldPassword(_ password: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepassword(_ password: String, rePassword: String) -> ValidationResult
}

struct ChangePasswordUseCase: ChangePasswordUseCaseType, Login {
    var loginGateway: LoginGatewayType
    
    func changePassword(_ accountID: Int, password: String) -> Observable<Bool> {
        loginGateway.changePassword(accountID, password: password)
    }
    
    func validateOldPassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return .failure(ValidationError(message: "Vui lòng nhập mật khẩu"))
        } else if password.count >= 6 && password.count <= 32 {
            if AccountStorage().getPassword() == password {
                return .success(())
            } else {
                return .failure(ValidationError(message: "Mật khẩu cũ không đúng, vui lòng nhập lại"))
            }
        } else {
            return .failure(ValidationError(message: "Mật khẩu phải lớn hơn 6 và nhỏ hơn 32 ký tự"))
        }
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return .failure(ValidationError(message: "Vui lòng nhập mật khẩu"))
        } else if password.count >= 6 && password.count <= 32 {
            return .success(())
        } else {
            return .failure(ValidationError(message: "Mật khẩu phải lớn hơn 6 và nhỏ hơn 32 ký tự"))
        }
    }
    
    func validateRepassword(_ password: String, rePassword: String) -> ValidationResult {
        if password.isEmpty || rePassword.isEmpty {
            return .failure(ValidationError(message: "Vui lòng nhập mật khẩu"))
        } else if rePassword.count >= 6 && rePassword.count <= 32 && password == rePassword{
            return .success(())
        } else {
            return .failure(ValidationError(message: "Mật khẩu không khớp"))
        }
    }
}

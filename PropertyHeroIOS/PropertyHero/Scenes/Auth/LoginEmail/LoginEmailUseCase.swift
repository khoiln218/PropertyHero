//
//  LoginEmailUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/20/23.
//

import RxSwift
import Dto
import ValidatedPropertyKit

protocol LoginEmailUseCaseType {
    func login(_ username: String, password: String) -> Observable<[Account]>
    func validateUsername(_ username: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
}

struct LoginEmailUseCase: LoginEmailUseCaseType, Login {
    var loginGateway: LoginGatewayType
    
    func login(_ username: String, password: String) -> Observable<[Account]> {
        loginGateway.login(username, password: password)
    }
    
    func validateUsername(_ username: String) -> ValidationResult {
        if username.isEmpty {
            return .failure(ValidationError(message: "Vui lòng nhập email hoặc số điện thoại"))
        } else if isValidPhoneNumber(phone: username) || isValidEmail(email: username) {
            return .success(())
        } else {
            return .failure(ValidationError(message: "Email hoặc số điện thoại không đúng định dạng"))
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
    
    func isValidPhoneNumber(phone: String) -> Bool {
        let phoneRegEx = "^(\\+84|0)[35789][0-9]{8}$"
        
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

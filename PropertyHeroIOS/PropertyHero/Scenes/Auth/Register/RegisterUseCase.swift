//
//  RegisterUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/21/23.
//

import RxSwift
import Dto
import ValidatedPropertyKit

protocol RegisterUseCaseType {
    func verify(_ username: String) -> Observable<[Account]>
    func register(_ username: String, password: String, fullname: String, phoneNumber: String) -> Observable<Bool>
    func login(_ username: String, password: String) -> Observable<[Account]>
    func checkRegister(_ success: Bool) -> ValidationResult
    func verifyUsername(_ accounts: [Account]) -> ValidationResult
    func validateUsername(_ username: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepassword(_ password: String, rePassword: String) -> ValidationResult
    func validateFullname(_ fullname: String) -> ValidationResult
    func validatePhoneNumber(_ phoneNumber: String) -> ValidationResult
}

struct RegisterUseCase: RegisterUseCaseType, Login {
    var loginGateway: LoginGatewayType
    
    func verify(_ username: String) -> Observable<[Account]> {
        loginGateway.verify(username)
    }
    
    func register(_ username: String, password: String, fullname: String, phoneNumber: String) -> Observable<Bool> {
        loginGateway.register(username, password: password, fullname: fullname, phoneNumber: phoneNumber)
    }
    
    func login(_ email: String, password: String) -> Observable<[Account]> {
        return loginGateway.login(email, password: password)
    }
    
    func checkRegister(_ success: Bool) -> ValidationResult {
        if success {
            return .success(())
        } else {
            return .failure(ValidationError(message: "Lỗi hệ thống vui lòng thử lại"))
        }
    }
    
    func verifyUsername(_ accounts: [Account]) -> ValidationResult {
        if accounts.isEmpty {
            return .success(())
        } else {
            return .failure(ValidationError(message: "Email hoặc số điện thoại đã tồn tại"))
        }
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
    
    func validateRepassword(_ password: String, rePassword: String) -> ValidationResult {
        if password.isEmpty || rePassword.isEmpty {
            return .failure(ValidationError(message: "Vui lòng nhập mật khẩu"))
        } else if rePassword.count >= 6 && rePassword.count <= 32 && password == rePassword{
            return .success(())
        } else {
            return .failure(ValidationError(message: "Mật khẩu không khớp"))
        }
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

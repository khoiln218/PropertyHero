//
//  AccountDeletionUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/26/23.
//

import RxSwift
import Dto
import ValidatedPropertyKit

protocol AccountDeletionUseCaseType {
    func delete(_ username: String, password: String) -> Observable<Bool>
    func validatePassword(_ password: String) -> ValidationResult
}

struct AccountDeletionUseCase: AccountDeletionUseCaseType, Login {
    var loginGateway: LoginGatewayType
    
    func delete(_ username: String, password: String) -> Observable<Bool> {
        loginGateway.accountDeletion(username, password: password)
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        if AccountStorage().getAccount().AccountType != AccountType.hero.rawValue {
            return .success(())
        }
        if password.isEmpty {
            return .failure(ValidationError(message: "Vui lòng nhập mật khẩu"))
        } else if password.count >= 6 && password.count <= 32 {
            return .success(())
        } else {
            return .failure(ValidationError(message: "Mật khẩu phải lớn hơn 6 và nhỏ hơn 32 ký tự"))
        }
    }
}

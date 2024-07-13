//
//  FeedbackEmailUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/28/23.
//

import RxSwift
import Dto
import ValidatedPropertyKit

protocol FeedbackEmailUseCaseType {
    func validateFullname(_ fullname: String) -> ValidationResult
    func validatePhoneNumber(_ phoneNumber: String) -> ValidationResult
    func validateContent(_ content: String) -> ValidationResult
}

struct FeedbackEmailUseCase: FeedbackEmailUseCaseType {
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
    
    func validateContent(_ content: String) -> ValidationResult {
        if content.isEmpty {
            return .failure(ValidationError(message: "Vui lòng nhập nội dung"))
        } else {
            return .success(())
        }
    }
    
    func isValidPhoneNumber(phone: String) -> Bool {
        let phoneRegEx = "^(\\+84|0)[35789][0-9]{8}$"
        
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }
}

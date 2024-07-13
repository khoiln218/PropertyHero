//
//  FeedbackEmailViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/28/23.
//

import MGArchitecture
import RxSwift
import RxCocoa
import Dto

struct FeedbackEmailViewModel {
    let navigator: FeedbackEmailNavigatorType
    let useCase: FeedbackEmailUseCaseType
}

// MARK: - ViewModel
extension FeedbackEmailViewModel: ViewModel {
    struct Input {
        let fullname: Driver<String>
        let phoneNumber: Driver<String>
        let content: Driver<String>
        let send: Driver<Void>
    }
    
    struct Output {
        @Property var fullnameValidation = ValidationResult.success(())
        @Property var phoneNumberValidation = ValidationResult.success(())
        @Property var contentValidation = ValidationResult.success(())
        @Property var isSuccessful: Bool?
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let fullnameValidation = Driver.combineLatest(input.fullname, input.send)
            .map { $0.0 }
            .map(useCase.validateFullname(_:))
        
        fullnameValidation
            .drive(output.$fullnameValidation)
            .disposed(by: disposeBag)
        
        
        let phoneNumberValidation = Driver.combineLatest(input.phoneNumber, input.send)
            .map { $0.0 }
            .map(useCase.validatePhoneNumber(_:))
        
        phoneNumberValidation
            .drive(output.$phoneNumberValidation)
            .disposed(by: disposeBag)
        
        let contentValidation = Driver.combineLatest(input.content, input.send)
            .map { $0.0 }
            .map(useCase.validateContent(_:))

        contentValidation
            .drive(output.$contentValidation)
            .disposed(by: disposeBag)
        
        let isNextEnabled = Driver.and(
            fullnameValidation.map { $0.isValid },
            phoneNumberValidation.map { $0.isValid },
            contentValidation.map { $0.isValid }
        ).startWith(true)
        
        let send = input.send
            .withLatestFrom(isNextEnabled)
            .filter { $0 }
        
        send
            .drive(output.$isSuccessful)
            .disposed(by: disposeBag)
        
        return output
    }
}

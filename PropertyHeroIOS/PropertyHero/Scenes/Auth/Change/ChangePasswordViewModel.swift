//
//  ChangePasswordViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/29/23.
//

import MGArchitecture
import RxSwift
import RxCocoa
import Dto

struct ChangePasswordViewModel {
    let navigator: ChangePasswordNavigatorType
    let useCase: ChangePasswordUseCaseType
}

// MARK: - ViewModel
extension ChangePasswordViewModel: ViewModel {
    struct Input {
        let oldPassword: Driver<String>
        let newPassword: Driver<String>
        let rePassword: Driver<String>
        let update: Driver<Void>
    }
    
    struct Output {
        @Property var isSuccessful: Bool?
        @Property var oldPassswordValidation = ValidationResult.success(())
        @Property var passwordValidation = ValidationResult.success(())
        @Property var rePasswordValidation = ValidationResult.success(())
        @Property var error: Error?
        @Property var isLoading = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let oldPasswordValidation = Driver.combineLatest(input.oldPassword, input.update)
            .map { $0.0 }
            .map(useCase.validateOldPassword(_:))
        
        oldPasswordValidation
            .drive(output.$oldPassswordValidation)
            .disposed(by: disposeBag)
        
        let passwordValidation = Driver.combineLatest(input.newPassword, input.update)
            .map { $0.0 }
            .map(useCase.validatePassword(_:))
        
        passwordValidation
            .drive(output.$passwordValidation)
            .disposed(by: disposeBag)
        
        let rePasswordValidation = Driver.combineLatest(input.newPassword, input.rePassword, input.update)
            .map { useCase.validateRepassword($0.0, rePassword: $0.1) }

        rePasswordValidation
            .drive(output.$rePasswordValidation)
            .disposed(by: disposeBag)
        
        let isNextEnabled = Driver.and(
            oldPasswordValidation.map { $0.isValid },
            passwordValidation.map { $0.isValid },
            rePasswordValidation.map { $0.isValid }
        ).startWith(true)
        
        let changePassword = input.update
            .withLatestFrom(isNextEnabled)
            .filter { $0 }
            .withLatestFrom(input.newPassword)
            .flatMapLatest { newPassword in
                return self.useCase.changePassword(AccountStorage().getAccount().Id, password: newPassword)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        changePassword
            .drive(output.$isSuccessful)
            .disposed(by: disposeBag)
        
        errorTracker
            .asDriver()
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        activityIndicator
            .asDriver()
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        return output
    }
}

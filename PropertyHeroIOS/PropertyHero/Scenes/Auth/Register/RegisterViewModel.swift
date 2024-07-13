//
//  RegisterViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/21/23.
//

import MGArchitecture
import RxSwift
import RxCocoa
import Dto

struct RegisterViewModel {
    let navigator: RegisterNavigatorType
    let useCase: RegisterUseCaseType
}

// MARK: - ViewModel
extension RegisterViewModel: ViewModel {
    struct Input {
        let trigger: Driver<Void>
        let username: Driver<String>
        let password: Driver<String>
        let rePassword: Driver<String>
        let fullname: Driver<String>
        let phoneNumber: Driver<String>
        let register: Driver<Void>
    }
    
    struct Output {
        @Property var usernameValidation = ValidationResult.success(())
        @Property var passwordValidation = ValidationResult.success(())
        @Property var rePasswordValidation = ValidationResult.success(())
        @Property var fullnameValidation = ValidationResult.success(())
        @Property var phoneNumberValidation = ValidationResult.success(())
        @Property var accounts: [Account]?
        @Property var error: Error?
        @Property var isLoading = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let loginFail = PublishSubject<Error>()
        
        let usernameValidation = Driver.combineLatest(input.username, input.register)
            .map { $0.0 }
            .map(useCase.validateUsername(_:))
        
        let passwordValidation = Driver.combineLatest(input.password, input.register)
            .map { $0.0 }
            .map(useCase.validatePassword(_:))
        
        passwordValidation
            .drive(output.$passwordValidation)
            .disposed(by: disposeBag)
        
        let rePasswordValidation = Driver.combineLatest(input.password, input.rePassword, input.register)
            .map { useCase.validateRepassword($0.0, rePassword: $0.1) }

        rePasswordValidation
            .drive(output.$rePasswordValidation)
            .disposed(by: disposeBag)
        
        let fullnameValidation = Driver.combineLatest(input.fullname, input.register)
            .map { $0.0 }
            .map(useCase.validateFullname(_:))
        
        fullnameValidation
            .drive(output.$fullnameValidation)
            .disposed(by: disposeBag)
        
        
        let phoneNumberValidation = Driver.combineLatest(input.phoneNumber, input.register)
            .map { $0.0 }
            .map(useCase.validatePhoneNumber(_:))
        
        phoneNumberValidation
            .drive(output.$phoneNumberValidation)
            .disposed(by: disposeBag)
        
        let isNextEnabled = Driver.and(
            usernameValidation.map { $0.isValid },
            passwordValidation.map { $0.isValid },
            rePasswordValidation.map { $0.isValid },
            fullnameValidation.map { $0.isValid },
            phoneNumberValidation.map { $0.isValid }
        ).startWith(true)
        
        let verify = input.register
            .withLatestFrom(isNextEnabled)
            .filter { $0 }
            .withLatestFrom(Driver.combineLatest(
                input.username,
                input.password
            ))
            .flatMapLatest { username, password in
                return self.useCase.verify(username)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        let usernameVerify = verify
            .map(useCase.verifyUsername(_:))
        
        let register = usernameVerify
            .map { $0.isValid }
            .filter { $0 }
            .withLatestFrom(Driver.combineLatest(
                input.username,
                input.password,
                input.fullname,
                input.phoneNumber
            ))
            .flatMapLatest { username, password, fullname, phonenumber in
                return self.useCase.register(username, password: password, fullname: fullname, phoneNumber: phonenumber)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        let checkRegister = register
            .map(useCase.checkRegister(_:))
        
        Driver.merge(usernameValidation, usernameVerify, checkRegister)
            .drive(output.$usernameValidation)
            .disposed(by: disposeBag)
        
        let login = checkRegister
            .map { $0.isValid }
            .filter { $0 }
            .withLatestFrom(Driver.combineLatest(
                input.username,
                input.password
            ))
            .flatMapLatest { username, password in
                return self.useCase.login(username, password: password)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        login
            .drive(output.$accounts)
            .disposed(by: disposeBag)
        
        let error = Driver.merge(
            errorTracker.asDriver(),
            loginFail.asDriverOnErrorJustComplete()
        )
        
        error
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        activityIndicator
            .asDriver()
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        return output
    }
}

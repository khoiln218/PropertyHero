//
//  LoginEmailViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/20/23.
//

import MGArchitecture
import RxSwift
import RxCocoa
import Dto

struct LoginEmailViewModel {
    let navigator: LoginEmailNavigatorType
    let useCase: LoginEmailUseCaseType
}

// MARK: - ViewModel
extension LoginEmailViewModel: ViewModel {
    struct Input {
        let trigger: Driver<Void>
        let username: Driver<String>
        let password: Driver<String>
        let login: Driver<Void>
    }
    
    struct Output {
        @Property var usernameValidation = ValidationResult.success(())
        @Property var passwordValidation = ValidationResult.success(())
        @Property var accounts: [Account]?
        @Property var error: Error?
        @Property var isLoading = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let loginFail = PublishSubject<Error>()
        
        let usernameValidation = Driver.combineLatest(input.username, input.login)
            .map { $0.0 }
            .map(useCase.validateUsername(_:))
        
        usernameValidation
            .drive(output.$usernameValidation)
            .disposed(by: disposeBag)
        
        let passwordValidation = Driver.combineLatest(input.password, input.login)
            .map { $0.0 }
            .map(useCase.validatePassword(_:))
        
        passwordValidation
            .drive(output.$passwordValidation)
            .disposed(by: disposeBag)
        
        let isNextEnabled = Driver.and(
            usernameValidation.map { $0.isValid },
            passwordValidation.map { $0.isValid }
        ).startWith(true)
        
        let login = input.login
            .withLatestFrom(isNextEnabled)
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

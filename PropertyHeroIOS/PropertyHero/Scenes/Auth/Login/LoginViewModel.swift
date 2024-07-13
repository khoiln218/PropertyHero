//
//  LoginViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/4/23.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct LoginViewModel {
    let navigator: LoginNavigatorType
    let useCase: LoginUseCaseType
}

// MARK: - ViewModel
extension LoginViewModel: ViewModel {
    struct Input {
        let login: Driver<Account>
    }
    
    struct Output {
        @Property var accounts: [Account]?
        @Property var error: Error?
        @Property var isLoading = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let login = input.login
            .flatMapLatest { account in
                return self.useCase.socialLogin(account)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        login
            .drive(output.$accounts)
            .disposed(by: disposeBag)
        
        errorTracker.asDriver()
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        activityIndicator
            .asDriver()
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        return output
    }
}

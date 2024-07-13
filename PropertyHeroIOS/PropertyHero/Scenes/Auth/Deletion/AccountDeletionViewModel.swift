//
//  AccountDeletionViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/26/23.
//

import MGArchitecture
import RxSwift
import RxCocoa
import Dto

struct AccountDeletionViewModel {
    let navigator: AccountDeletionNavigatorType
    let useCase: AccountDeletionUseCaseType
}

// MARK: - ViewModel
extension AccountDeletionViewModel: ViewModel {
    struct Input {
        let account: Driver<Account>
        let password: Driver<String>
        let delete: Driver<Void>
    }
    
    struct Output {
        @Property var passwordValidation = ValidationResult.success(())
        @Property var isSuccessful: Bool?
        @Property var error: Error?
        @Property var isLoading = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let passwordValidation = Driver.combineLatest(input.password, input.delete)
            .map { $0.0 }
            .map(useCase.validatePassword(_:))
        
        passwordValidation
            .drive(output.$passwordValidation)
            .disposed(by: disposeBag)
        
        let delete = input.delete
            .withLatestFrom(passwordValidation.map { $0.isValid })
            .filter { $0 }
            .withLatestFrom(Driver.combineLatest(
                input.account,
                input.password
            ))
            .flatMapLatest { account, password in
                return self.useCase.delete(account.UserName, password: password)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        delete
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

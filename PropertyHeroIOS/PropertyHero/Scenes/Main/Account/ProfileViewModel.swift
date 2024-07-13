//
//  ProfileViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/26/23.
//

import MGArchitecture
import RxSwift
import RxCocoa
import MGAPIService

struct ProfileViewModel {
    let navigator: ProfileNavigatorType
    let useCase: ProfileUseCaseType
    let account: Account
}

// MARK: - ViewModel
extension ProfileViewModel: ViewModel {
    struct Input {
        let trigger: Driver<Void>
        let avatar: Driver<APIUploadData>
    }
    
    struct Output {
        @Property var account = Account()
        @Property var isSuccessful: Bool?
        @Property var error: Error?
        @Property var isLoading = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(account: account)
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        input.avatar
            .flatMapLatest { avatar -> Driver<Bool> in
                let account = AccountStorage().getAccount()
                return self.useCase.changeAvatar(account.Id, username: account.UserName, avatar: avatar)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
            .drive(output.$isSuccessful)
            .disposed(by: disposeBag)
        
        activityIndicator
            .asDriver()
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        errorTracker
            .asDriver()
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        return output
    }
}

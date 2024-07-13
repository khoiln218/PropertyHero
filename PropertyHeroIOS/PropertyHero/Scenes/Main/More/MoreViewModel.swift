//
//  MoreViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct MoreViewModel {
    let navigator: MoreNavigatorType
    let useCase: MoreUseCaseType
}

// MARK: - ViewModel
extension MoreViewModel: ViewModel {
    struct Input {
        let load: Driver<Void>
    }
    
    struct Output {
        @Property var account: Account?
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let newAccount = input.load
            .flatMapLatest {
                self.useCase.accountInfo(AccountStorage().getAccount().Id)
                    .filter { !$0.isEmpty }
                    .map { $0[0] }
                    .unwrap()
                    .do(onNext: {
                        AccountStorage().saveAccount($0)
                    })
                    .asDriverOnErrorJustComplete()
            }
        
        newAccount
            .drive(output.$account)
            .disposed(by: disposeBag)
        
        return output
    }
}

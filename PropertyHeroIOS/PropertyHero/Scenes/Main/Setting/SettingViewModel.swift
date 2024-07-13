//
//  SettingViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/2/23.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct SettingViewModel {
    let navigator: SettingNavigatorType
    let useCase: SettingUseCaseType
}

// MARK: - ViewModel
extension SettingViewModel: ViewModel {
    struct Input {
        let trigger: Driver<Void>
        let province: Driver<Province>
    }
    
    struct Output {
        @Property var proinces: [Province]?
        @Property var error: Error?
        @Property var isLoading = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        let loading = activityIndicator
            .asDriver()
        
        let provinceList = input.trigger
            .flatMapLatest { _ in
                self.useCase.getProvinces()
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        provinceList
            .drive(output.$proinces)
            .disposed(by: disposeBag)
        
        loading
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        errorTracker
            .asDriver()
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        return output
    }
}

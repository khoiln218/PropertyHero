//
//  ReportViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/24/23.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct ReportViewModel {
    let navigator: ReportNavigatorType
    let useCase: ReportUseCaseType
    let productId: Int
}

// MARK: - ViewModel
extension ReportViewModel: ViewModel {
    struct Input {
        let warningType: Driver<Int>
        let content: Driver<String>
        let report: Driver<Void>
    }
    
    struct Output {
        @Property var isSuccessful: Bool?
        @Property var error: Error?
        @Property var isLoading = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        input.report
            .withLatestFrom(Driver.combineLatest(
            input.warningType,
            input.content
        ))
            .flatMapLatest {
                let content = "Nhập mô tả thêm" == $0.1 ? "" : $0.1
                return self.useCase.sendReport(productId, accountId: AccountStorage().getAccount().Id, type: $0.0, content: content)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
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

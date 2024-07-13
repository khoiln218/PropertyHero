//
//  NotificationViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct NotificationViewModel {
    let navigator: NotificationNavigatorType
    let useCase: NotificationUseCaseType
}

// MARK: - ViewModel
extension NotificationViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        return output
    }
}

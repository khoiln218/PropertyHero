//
//  AboutViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/2/23.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct AboutViewModel {
    let navigator: AboutNavigatorType
    let useCase: AboutUseCaseType
}

// MARK: - ViewModel
extension AboutViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        return output
    }
}

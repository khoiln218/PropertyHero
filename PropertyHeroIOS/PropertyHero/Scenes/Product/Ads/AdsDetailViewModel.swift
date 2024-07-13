//
//  AdsDetailViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/24/23.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct AdsDetailViewModel {
    let navigator: AdsDetailNavigatorType
    let useCase: AdsDetailUseCaseType
    let relocation: Relocation
}

// MARK: - ViewModel
extension AdsDetailViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        @Property var relocation: Relocation?
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(relocation: relocation)
        return output
    }
}

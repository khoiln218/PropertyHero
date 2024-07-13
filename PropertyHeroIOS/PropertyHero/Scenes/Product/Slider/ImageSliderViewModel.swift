//
//  ImageSliderViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/2/23.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct ImageSliderViewModel {
    let navigator: ImageSliderNavigatorType
    let useCase: ImageSliderUseCaseType
    let images: String
    let position: Int
}

// MARK: - ViewModel
extension ImageSliderViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        @Property var data: [String: Any]?
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(data: ["images": images, "position": position])
        return output
    }
}

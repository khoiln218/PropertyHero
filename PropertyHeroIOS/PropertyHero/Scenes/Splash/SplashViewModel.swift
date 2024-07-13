//
//  MainViewModel.swift
//  BaoDongThap
//
//  Created by KHOI LE on 9/20/22.
//

import RxSwift
import RxCocoa
import MGArchitecture
import CoreLocation

struct SplashViewModel {
    let navigator: SplashNavigatorType
    let useCase: SplashUseCaseType
}

// MARK: - ViewModel
extension SplashViewModel: ViewModel {
    struct Input {
        let load: Driver<CLLocationCoordinate2D>
    }
    
    struct Output {

    }

    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.load
            .drive(onNext: { latlng in
                self.navigator.toMain()
            })
            .disposed(by: disposeBag)

        return output
    }
}

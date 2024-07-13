//
//  SearchByLocationViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/11/23.
//

import MGArchitecture
import RxSwift
import RxCocoa
import CoreLocation

struct SearchByLocationViewModel {
    let navigator: SearchByLocationNavigatorType
    let useCase: SearchByLocationUseCaseType
}

// MARK: - ViewModel
extension SearchByLocationViewModel: ViewModel {
    struct Input {
        let trigger: Driver<Void>
        let province: Driver<Province>
        let district: Driver<District>
        let search: Driver<Void>
    }
    
    struct Output {
        @Property var proinces: [Province]?
        @Property var districts: [District]?
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
        
        let districtList = input.province
            .flatMapLatest { province in
                self.useCase.getDistricts(province.Id)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        provinceList
            .drive(output.$proinces)
            .disposed(by: disposeBag)
        
        districtList
            .drive(output.$districts)
            .disposed(by: disposeBag)
        
        let searchData = Driver.combineLatest(
            input.district,
            input.province
        )
        
        input.search
            .withLatestFrom(searchData)
            .drive(onNext: { district, province in
                self.navigator.toMapView(district.Name + ", " + province.Name, latlng: CLLocationCoordinate2D(latitude: district.Latitude, longitude: district.Longitude), type: .all)
            })
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

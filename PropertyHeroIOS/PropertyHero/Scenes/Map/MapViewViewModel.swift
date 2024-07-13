//
//  MapViewViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import MGArchitecture
import RxSwift
import RxCocoa
import CoreLocation
import GoogleMaps

struct MapViewViewModel {
    let navigator: MapViewNavigatorType
    let useCase: MapViewUseCaseType
    let title: String
    let latlng: CLLocationCoordinate2D
    let type: PropertyType
}

// MARK: - ViewModel
extension MapViewViewModel: ViewModel {
    struct Input {
        let filter: Driver<Void>
        let cameraChaged: Driver<GMSCoordinateBounds>
        let viewmore: Driver<Void>
    }
    
    struct Output {
        @Property var title: String?
        @Property var latlng: CLLocationCoordinate2D?
        @Property var products: [Product] = []
        @Property var error: Error?
        @Property var isLoading = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(title: title, latlng: latlng)
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        let loading = activityIndicator.asDriver()
        let error = errorTracker.asDriver()
        
        let products = input.cameraChaged
            .flatMapLatest { bounds -> Driver<[Product]> in
                let filterSet = FilterStorage().getFilterSet()
                let searchInfo = SearchInfo(
                    startLat: bounds.southWest.latitude,
                    startLng: bounds.southWest.longitude,
                    endLat: bounds.northEast.latitude,
                    endLng: bounds.northEast.longitude,
                    distance: 0.0,
                    propertyType: Constants.undefined.rawValue,
                    propertyID: self.type.rawValue == 0 ? filterSet.propertyID : self.type.rawValue,
                    minPrice: filterSet.minPrice,
                    maxPrice: filterSet.maxPrice,
                    minArea: filterSet.minArea,
                    maxArea: filterSet.maxArea,
                    bed: filterSet.bed,
                    bath: filterSet.bath,
                    status: Constants.undefined.rawValue,
                    pageNo: 1
                )
                return self.useCase.search(searchInfo)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        input.viewmore
            .withLatestFrom(input.cameraChaged)
            .drive(onNext: { bounds in
                let filterSet = FilterStorage().getFilterSet()
                let searchInfo = SearchInfo(
                    startLat: bounds.southWest.latitude,
                    startLng: bounds.southWest.longitude,
                    endLat: bounds.northEast.latitude,
                    endLng: bounds.northEast.longitude,
                    distance: 0.0,
                    propertyType: Constants.undefined.rawValue,
                    propertyID: self.type.rawValue == 0 ? filterSet.propertyID : self.type.rawValue,
                    minPrice: filterSet.minPrice,
                    maxPrice: filterSet.maxPrice,
                    minArea: filterSet.minArea,
                    maxArea: filterSet.maxArea,
                    bed: filterSet.bed,
                    bath: filterSet.bath,
                    status: Constants.undefined.rawValue,
                    pageNo: 1
                )
                self.navigator.toProductList(searchInfo, title: title)
            })
            .disposed(by: disposeBag)
        
        input.filter
            .flatMapLatest { _ -> Driver<FilterChangedDelegate> in
                self.navigator.toFilter()
            }
            .drive(onNext: { delegate in
                switch delegate {
                case .onChanged(_):
                    Driver.just(()).withLatestFrom(input.cameraChaged)
                        .flatMapLatest { bounds in
                            let filterSet = FilterStorage().getFilterSet()
                            let searchInfo = SearchInfo(
                                startLat: bounds.southWest.latitude,
                                startLng: bounds.southWest.longitude,
                                endLat: bounds.northEast.latitude,
                                endLng: bounds.northEast.longitude,
                                distance: 0.0,
                                propertyType: Constants.undefined.rawValue,
                                propertyID: self.type.rawValue == 0 ? filterSet.propertyID : self.type.rawValue,
                                minPrice: filterSet.minPrice,
                                maxPrice: filterSet.maxPrice,
                                minArea: filterSet.minArea,
                                maxArea: filterSet.maxArea,
                                bed: filterSet.bed,
                                bath: filterSet.bath,
                                status: Constants.undefined.rawValue,
                                pageNo: 1
                            )
                            return self.useCase.search(searchInfo)
                                .trackError(errorTracker)
                                .trackActivity(activityIndicator)
                                .asDriverOnErrorJustComplete()
                        }
                        .drive(output.$products)
                        .disposed(by: disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        products
            .drive(output.$products)
            .disposed(by: disposeBag)
        
        loading
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        error
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        return output
    }
}

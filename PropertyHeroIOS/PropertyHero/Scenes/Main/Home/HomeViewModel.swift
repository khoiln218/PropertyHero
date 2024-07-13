//
//  HomeViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import MGArchitecture
import RxSwift
import RxCocoa
import CoreLocation

struct HomeViewModel {
    let navigator: HomeNavigatorType
    let useCase: HomeUseCaseType
}

// MARK: - ViewModel
extension HomeViewModel: ViewModel {
    struct Input {
        let locationChanged: Driver<CLLocationCoordinate2D>
        let markerSelected: Driver<Marker>
    }
    
    struct Output {
        @Property var sections:[Int: Any]?
        @Property var error: Error?
        @Property var isLoading = false
        @Property var isEmpty = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let bannerList = self.useCase.getBanner()
            .trackError(errorTracker)
            .trackActivity(activityIndicator)
            .asDriverOnErrorJustComplete()
        
        let markersUniversity = self.useCase.getMarkersByUniversity(3)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
        
        let markersLocation = input.locationChanged
            .flatMapLatest { latlng in
                self.useCase.getMarkersByLocation(latlng, numItems: 3)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let markerList = Driver.zip(markersLocation, markersUniversity)
        
        let sectionsLoad = Driver.combineLatest(bannerList, markerList)
            .map { banners, markers -> [Int: Any] in
                var sections = [Int: Any]()
                sections[0] = PageSectionViewModel<Banner> (
                    index: 0,
                    type: .banner,
                    title: "Banner",
                    items: banners
                )
                
                sections[1] = PageSectionViewModel<Marker> (
                    index: 1,
                    type: .findByArea,
                    title: "Việt Nam",
                    items: markers.0
                )
                
                sections[2] = PageSectionViewModel<Marker> (
                    index: 2,
                    type: .findByArea,
                    title: "Hàn Quốc",
                    items: markers.1
                )
                return sections
            }
        
        sectionsLoad
            .drive(output.$sections)
            .disposed(by: disposeBag)
        
        input.markerSelected
            .drive(onNext: { marker in
                self.navigator.toProductList(SearchInfo(startLat: marker.Latitude, startLng: marker.Longitude, distance: marker.distance, propertyType: Constants.undefined.rawValue), title: "\(marker.Name) \(marker.distance.clean)km")
            })
            .disposed(by: disposeBag)
        
        activityIndicator
            .asDriver()
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        errorTracker
            .asDriver()
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        return output
    }
}

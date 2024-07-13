//
//  FilterViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/25/23.
//

import MGArchitecture
import RxSwift
import RxCocoa
import Dto

enum FilterChangedDelegate {
    case onChanged(PropertyId)
}

struct FilterViewModel {
    let navigator: FilterNavigatorType
    let useCase: FilterUseCaseType
    let delegate: PublishSubject<FilterChangedDelegate>
}

// MARK: - ViewModel
extension FilterViewModel: ViewModel {
    struct Input {
        let load: Driver<Void>
        let update: Driver<Void>
        let reset: Driver<Void>
        let property: Driver<PropertyId>
        let minPrice: Driver<String>
        let maxPrice: Driver<String>
        let minArea: Driver<String>
        let maxArea: Driver<String>
        let bed: Driver<Int>
    }
    
    struct Output {
        @Property var priceValidation = ValidationResult.success(())
        @Property var areaValidation = ValidationResult.success(())
        @Property var filterSet: SearchInfo?
        @Property var properties: [PropertyId]?
        @Property var error: Error?
        @Property var isLoading = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let properties = input.load
            .flatMapLatest {_ -> Driver<[PropertyId]> in
                self.useCase.getListProperty()
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        properties
            .drive(output.$properties)
            .disposed(by: disposeBag)
        
        let filterSet = properties
            .map { _ in FilterStorage().getFilterSet() }
        
        let defaultFilter = input.reset
            .map { FilterStorage().defaultFilterSet() }
        
        Driver.merge(filterSet, defaultFilter)
            .drive(output.$filterSet)
            .disposed(by: disposeBag)
        
        let priceValidation = Driver.combineLatest(input.minPrice, input.maxPrice, input.update)
            .map { self.useCase.verifyPrice($0.0, maxPrice: $0.1) }
        
        priceValidation
            .drive(output.$priceValidation)
            .disposed(by: disposeBag)
        
        let areaValidation = Driver.combineLatest(input.minArea, input.maxArea, input.update)
            .map { self.useCase.verifyArea($0.0, maxArea: $0.1) }
        
        areaValidation
            .drive(output.$areaValidation)
            .disposed(by: disposeBag)
        
        let isNextEnabled = Driver.and(
            priceValidation.map { $0.isValid },
            areaValidation.map { $0.isValid }
        )
        
        input.update
            .withLatestFrom(isNextEnabled)
            .filter { $0 }
            .withLatestFrom(Driver.combineLatest(
                input.property,
                input.bed,
                input.minPrice,
                input.maxPrice,
                input.minArea,
                input.maxArea
            ))
            .drive(onNext: { propertyId, bed, minPrice, maxPrice, minArea, maxArea in
                var filterSet = FilterStorage().getFilterSet()
                filterSet.propertyID = Int(propertyId.id) ?? filterSet.propertyID
                filterSet.minPrice = Double(minPrice) ?? filterSet.minPrice
                filterSet.maxPrice = Double(maxPrice) ?? filterSet.maxPrice
                filterSet.minArea = Double(minArea) ?? filterSet.minArea
                filterSet.maxArea = Double(maxArea) ?? filterSet.maxArea
                filterSet.bed = bed
                FilterStorage().addFilterSet(filterSet)
                self.navigator.goBack()
                self.delegate.onNext(FilterChangedDelegate.onChanged(propertyId))
            })
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

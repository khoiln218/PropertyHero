//
//  ProductListViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import MGArchitecture
import RxSwift
import RxCocoa

struct ProductListViewModel {
    let navigator: ProductListNavigatorType
    let useCase: ProductListUseCaseType
    let searchInfo: SearchInfo
    let title: String
}

// MARK: - ViewModel
extension ProductListViewModel: ViewModel {
    struct Input {
        let load: Driver<Void>
        let reload: Driver<Void>
        let loadMore: Driver<Void>
        let selectProduct: Driver<IndexPath>
        let filter: Driver<Void>
    }
    
    struct Output {
        @Property var distance: Double?
        @Property var title: String?
        @Property var products: [Product] = []
        @Property var error: Error?
        @Property var isLoading = false
        @Property var isReloading = false
        @Property var isLoadingMore = false
        @Property var isEmpty = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(distance: searchInfo.distance, title: title)
        
        let errorTracker = ErrorTracker()
        let activityIndicator = PageActivityIndicator()
        let isLoading = activityIndicator.isLoading
        let isReloading = activityIndicator.isReloading
        let error = errorTracker.asDriver()
        
        let filterChanged = PublishSubject<Void>()
        
        input.filter
            .flatMapLatest { _ -> Driver<FilterChangedDelegate> in
                self.navigator.toFilter()
            }
            .drive(onNext: { delegate in
                switch delegate {
                case .onChanged(_):
                    filterChanged.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        let getPageInput = GetPageInput(
            pageActivityIndicator: activityIndicator,
            errorTracker: errorTracker,
            loadTrigger: input.load,
            reloadTrigger: Driver.merge(input.reload, filterChanged.asDriverOnErrorJustComplete()),
            loadMoreTrigger: input.loadMore,
            getItems: { _, page in
                let filterSet = FilterStorage().getFilterSet()
                let newFilter = SearchInfo(
                    startLat: searchInfo.startLat,
                    startLng: searchInfo.startLng,
                    endLat: searchInfo.endLat,
                    endLng: searchInfo.endLng,
                    distance: searchInfo.distance,
                    propertyType: Constants.undefined.rawValue,
                    propertyID: searchInfo.propertyID == 0 ? filterSet.propertyID : searchInfo.propertyID,
                    minPrice: filterSet.minPrice,
                    maxPrice: filterSet.maxPrice,
                    minArea: filterSet.minArea,
                    maxArea: filterSet.maxArea,
                    bed: filterSet.bed,
                    bath: filterSet.bath,
                    status: Constants.undefined.rawValue,
                    pageNo: page
                )
                return self.useCase.search(newFilter)
            }
        )
        
        let getPageResult = getPage(input: getPageInput)
        
        let productList = getPageResult.page
            .map { page -> [Product] in
                return page.items
            }
        
        productList
            .drive(output.$products)
            .disposed(by: disposeBag)
        
        select(trigger: input.selectProduct, items: productList)
            .drive(onNext: { product in
                self.navigator.toProductDetail(product.Id)
            })
            .disposed(by: disposeBag)
        
        checkIfDataIsEmpty(trigger: Driver.merge(isLoading, isReloading), items: productList)
            .drive(output.$isEmpty)
            .disposed(by: disposeBag)
        
        isLoading
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        error
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        isReloading
            .drive(output.$isReloading)
            .disposed(by: disposeBag)
        
        activityIndicator.isLoadingMore
            .drive(output.$isLoadingMore)
            .disposed(by: disposeBag)
        
        return output
    }
}

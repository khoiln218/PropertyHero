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
        let selectedProduct: Driver<Product>
        let viewAllHot: Driver<Void>
        let selectedDistrict: Driver<DistrictSuggest>
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
            .asDriverOnErrorJustComplete()
        
        let filterSet = FilterStorage().getFilterSet()
        let newFilter = SearchInfo(
            startLat: 10.619674722094736,
            startLng: 106.57988257706165,
            endLat: 10.965413634575896,
            endLng: 106.7968474701047,
            distance: 0,
            propertyType: Constants.undefined.rawValue,
            propertyID: 1000,
            minPrice: filterSet.minPrice,
            maxPrice: filterSet.maxPrice,
            minArea: filterSet.minArea,
            maxArea: filterSet.maxArea,
            bed: filterSet.bed,
            bath: filterSet.bath,
            status: Constants.undefined.rawValue
        )
        
        let productList = self.useCase.search(newFilter)
            .map { page -> [Product] in
                return page.items
            }
            .asDriverOnErrorJustComplete()
        
        let sectionsLoad = Driver.combineLatest(bannerList, productList)
            .map { banners, productList -> [Int: Any] in
                var sections = [Int: Any]()
                sections[0] = PageSectionViewModel<Banner> (
                    index: 0,
                    type: .banner,
                    title: "Banner",
                    items: banners
                )
                sections[1] = PageSectionViewModel<Product> (
                    index: 1,
                    type: .hot,
                    title: "Bất Động Sản HOT",
                    items: productList.suffix(4)
                )
                sections[2] = PageSectionViewModel<Bool> (
                    index: 2,
                    type: .middle,
                    title: "Middle",
                    items: []
                )
                sections[3] = PageSectionViewModel<DistrictSuggest> (
                    index: 3,
                    type: .hcm,
                    title: "TP. HCM",
                    items: getDistrictHCM()
                )
                sections[4] = PageSectionViewModel<DistrictSuggest> (
                    index: 4,
                    type: .hn,
                    title: "HN",
                    items: getDistrictHN()
                )
                return sections
            }
            .trackError(errorTracker)
            .trackActivity(activityIndicator)
            .asDriverOnErrorJustComplete()
        
        sectionsLoad
            .drive(output.$sections)
            .disposed(by: disposeBag)
        
        input.selectedProduct
            .drive(onNext: { product in
                self.navigator.toProductDetail(product.Id)
            })
            .disposed(by: disposeBag)
        
        input.viewAllHot
            .drive(onNext: { _ in
                self.navigator.toProductList(newFilter, title: "Bất Động Sản HOT")
            })
            .disposed(by: disposeBag)
        
        input.selectedDistrict
            .drive(onNext: { district in
                self.navigator.toMapView(district.Name, latlng: CLLocationCoordinate2D(latitude: district.Latitude, longitude: district.Longitude), type: .all)
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
    
    func getDistrictHCM() -> [DistrictSuggest] {
        var list:[DistrictSuggest] = []
        list.append(DistrictSuggest(Latitude: 10.780640700,Longitude: 106.699092600,ImgRes: "q1", Id: 0, Name: "Quận 1"))
        list.append(DistrictSuggest(Latitude: 10.782868900,Longitude: 106.686425100,ImgRes: "q3", Id: 1, Name: "Quận 3"))
        list.append(DistrictSuggest(Latitude: 10.766533400,Longitude: 106.706003300,ImgRes: "q4", Id: 2, Name: "Quận 4"))
        list.append(DistrictSuggest(Latitude: 10.755863600,Longitude: 106.667370800,ImgRes: "q5", Id: 3, Name: "Quận 5"))
        list.append(DistrictSuggest(Latitude: 10.732338400,Longitude: 106.726505200,ImgRes: "q7", Id: 4, Name: "Quận 7"))
        list.append(DistrictSuggest(Latitude: 10.767627200,Longitude: 106.666413500,ImgRes: "q10", Id: 5, Name: "Quận 10"))
        list.append(DistrictSuggest(Latitude: 10.803239000,Longitude: 106.696714500,ImgRes: "q_bthanh", Id: 6, Name: "Quận Bình Thạnh"))
        list.append(DistrictSuggest(Latitude: 10.831512900,Longitude: 106.669296700,ImgRes: "q_gvap", Id: 7, Name: "Quận Gò Vấp"))
        list.append(DistrictSuggest(Latitude: 10.795046400,Longitude: 106.676008200,ImgRes: "q_pn", Id: 8, Name: "Quận Phú Nhuận"))
        list.append(DistrictSuggest(Latitude: 10.848243600,Longitude: 106.772226000,ImgRes: "q_tduc", Id: 9, Name: "TP.Thủ Đức"))
        return list
    }
    
    func getDistrictHN() -> [DistrictSuggest] {
        var list:[DistrictSuggest] = []
        list.append(DistrictSuggest(Latitude: 21.033825600,Longitude: 105.814392200,ImgRes: "q_bdinh", Id: 0, Name: "Quận Ba Đình"))
        list.append(DistrictSuggest(Latitude: 21.030955600,Longitude: 105.801087700,ImgRes: "q_cgiay", Id: 1, Name: "Quận Cầu Giấy"))
        list.append(DistrictSuggest(Latitude: 21.020009300,Longitude: 105.830622200,ImgRes: "q_dda", Id: 2, Name: "Quận Đống Đa"))
        list.append(DistrictSuggest(Latitude: 21.009990600,Longitude: 105.849707500,ImgRes: "q_hbtrung", Id: 3, Name: "Quận Hai Ba Trưng"))
        list.append(DistrictSuggest(Latitude: 21.028745000,Longitude: 105.850717000,ImgRes: "q_hkiem", Id: 4, Name: "Quận Hoàng Kiếm"))
        list.append(DistrictSuggest(Latitude: 20.968109300,Longitude: 105.848415300,ImgRes: "q_hmai", Id: 5, Name: "Quận Hoàng Mai"))
        list.append(DistrictSuggest(Latitude: 20.994643000,Longitude: 105.799816400,ImgRes: "q_txuan", Id: 6, Name: "Quận Thanh Xuân"))
        return list
    }
}

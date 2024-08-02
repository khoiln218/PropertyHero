//
//  HomeViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import CoreLocation

final class HomeViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var viewModel: HomeViewModel!
    var disposeBag = DisposeBag()
    
    private let manager = CLLocationManager()
    private var latlng: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: DefaultStorage().getLastLat(), longitude: DefaultStorage().getLastLng())
    
    private var locationChanged = PublishSubject<CLLocationCoordinate2D>()
    private var selectedProduct = PublishSubject<Product>()
    private var viewAllHot = PublishSubject<Void>()
    private var selectedDistrict = PublishSubject<DistrictSuggest>()
    
    var sections = [Int: Any]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        manager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    deinit {
        logDeinit()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Methods
    
    private func configView() {
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: HeaderCell.self)
            $0.register(cellType: HotPropertyCell.self)
            $0.register(cellType: MiddlePageCell.self)
            $0.register(cellType: DistrictAICell.self)
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.headerReferenceSize = CGSize.zero
        }
        collectionView.contentInset = UIEdgeInsets(top: -collectionView.contentInset.top, left: 0, bottom: 0, right: 0)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func bindViewModel() {
        let input = HomeViewModel.Input(
            locationChanged: locationChanged.asDriverOnErrorJustComplete(),
            selectedProduct: selectedProduct.asDriverOnErrorJustComplete(),
            viewAllHot: viewAllHot.asDriverOnErrorJustComplete(),
            selectedDistrict: selectedDistrict.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        DispatchQueue.global().async { [unowned self] in
            if CLLocationManager.locationServicesEnabled() {
                switch self.manager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    self.locationChanged.onNext(latlng)
                case .authorizedAlways, .authorizedWhenInUse:
                    self.manager.startUpdatingLocation()
                @unknown default:
                    self.locationChanged.onNext(latlng)
                    break
                }
            } else {
                self.locationChanged.onNext(latlng)
            }
        }
        
        output.$sections
            .asDriver()
            .drive(onNext: { [unowned self] sections in
                if let sections = sections {
                    self.sections = sections
                    self.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        output.$error
            .asDriver()
            .unwrap()
            .drive(rx.error)
            .disposed(by: disposeBag)
        
        output.$isLoading
            .asDriver()
            .drive(rx.isLoading)
            .disposed(by: disposeBag)
        
        output.$isEmpty
            .asDriver()
            .drive(collectionView.isEmpty)
            .disposed(by: disposeBag)
    }
}

// MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        guard let latlng = location?.coordinate else { return }
        if latlng.latitude == self.latlng.latitude && latlng.longitude == self.latlng.longitude { return }
        self.latlng = latlng
        self.locationChanged.onNext(latlng)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let pageSectionBanner = sections[indexPath.row] as? PageSectionViewModel<Banner> {
            return collectionView.dequeueReusableCell(
                for: indexPath,
                cellType: HeaderCell.self
            )
            .then {
                $0.bindViewModel(pageSectionBanner)
                $0.selectBanner = { banner in
                    print(banner)
                }
                
                $0.selectOption = { [unowned self] option in
                    switch(option){
                    case .all:
                        self.viewModel.navigator.toMapView("Tất cả", latlng: CLLocationCoordinate2D(latitude: latlng.latitude, longitude: latlng.longitude), type: .all)
                    case .apartment:
                        self.viewModel.navigator.toMapView("Căn hộ", latlng: CLLocationCoordinate2D(latitude: latlng.latitude, longitude: latlng.longitude), type: .apartment)
                    case .room:
                        self.viewModel.navigator.toMapView("Phòng trọ", latlng: CLLocationCoordinate2D(latitude: latlng.latitude, longitude: latlng.longitude), type: .room)
                    }
                }
            }
        } else if let pageSectionProduct = sections[indexPath.row] as? PageSectionViewModel<Product> {
            return collectionView.dequeueReusableCell(
                for: indexPath,
                cellType: HotPropertyCell.self
            )
            .then {
                $0.bindViewModel(pageSectionProduct)
                $0.selectProduct = {[unowned self] product in
                    self.selectedProduct.onNext(product)
                }
                $0.viewMore = {[unowned self] _ in
                    self.viewAllHot.onNext(())
                }
            }
        } else if let pageSectionProduct = sections[indexPath.row] as? PageSectionViewModel<DistrictSuggest> {
            return collectionView.dequeueReusableCell(
                for: indexPath,
                cellType: DistrictAICell.self
            )
            .then {
                $0.bindViewModel(pageSectionProduct)
                $0.selectDistrict = {[unowned self] district in
                    self.selectedDistrict.onNext(district)
                }
            }
        }  else {
            return collectionView.dequeueReusableCell(
                for: indexPath,
                cellType: MiddlePageCell.self
            )
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if sections[indexPath.row] is PageSectionViewModel<Banner> {
            return CGSize(width: Dimension.SCREEN_WIDTH, height: Dimension.HEADER_HEIGHT)
        } else if sections[indexPath.row] is PageSectionViewModel<Product> {
            let pageSectionProduct = sections[indexPath.row] as! PageSectionViewModel<Product>
            var height = 0.0
            if pageSectionProduct.items.count > 2 {
                height = 2*Dimension.HOT_HEIGHT
            } else if pageSectionProduct.items.count > 0 {
                height = Dimension.HOT_HEIGHT
            }
            return CGSize(width: Dimension.SCREEN_WIDTH, height: height + 21 + 48 + 4*16)
        } else if sections[indexPath.row] is PageSectionViewModel<DistrictSuggest> {
            return CGSize(width: Dimension.SCREEN_WIDTH, height: 115 + 20 + 24)
        } else {
            return CGSize(width: Dimension.SCREEN_WIDTH, height: 130 + 21 + 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - StoryboardSceneBased
extension HomeViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

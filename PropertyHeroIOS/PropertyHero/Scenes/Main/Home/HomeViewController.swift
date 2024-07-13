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
    private var selectedMarker = PublishSubject<Marker>()
    
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
            $0.register(cellType: AreaSectionCell.self)
        }
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func bindViewModel() {
        let input = HomeViewModel.Input(
            locationChanged: locationChanged.asDriverOnErrorJustComplete(),
            markerSelected: selectedMarker.asDriverOnErrorJustComplete()
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
        } else {
            let pageSectionMarker = sections[indexPath.row] as! PageSectionViewModel<Marker>
            return collectionView.dequeueReusableCell(
                for: indexPath,
                cellType: AreaSectionCell.self
            )
            .then {
                $0.bindViewModel(pageSectionMarker)
                $0.selectMarker = { marker in
                    self.onChooseDistance(marker)
                }
                $0.viewMore = { index in
                    self.viewModel.navigator.toFindArea()
                }
            }
        }
    }
    
    func onChooseDistance(_ marker: Marker) {
        let alertViewController = UIAlertController(title: marker.Name, message: nil, preferredStyle: .alert)
        let distanceOne = UIAlertAction(title: "Bán kính 1km", style: .default, handler: { (_) in
            let newMarker = Marker(Id: marker.Id, Name: marker.Name, Latitude: marker.Latitude, Longitude: marker.Longitude, distance: 1.0)
            self.selectedMarker.onNext(newMarker)
        })
        let distanceThree = UIAlertAction(title: "Bán kính 3km", style: .default) { (_) in
            let newMarker = Marker(Id: marker.Id, Name: marker.Name, Latitude: marker.Latitude, Longitude: marker.Longitude, distance: 3.0)
            self.selectedMarker.onNext(newMarker)
        }
        let distanceFive = UIAlertAction(title: "Bán kính 5km", style: .default) { (_) in
            let newMarker = Marker(Id: marker.Id, Name: marker.Name, Latitude: marker.Latitude, Longitude: marker.Longitude, distance: 5.0)
            self.selectedMarker.onNext(newMarker)
        }
        let cancel = UIAlertAction(title: "Hủy bỏ", style: .cancel) { (_) in
        }
        alertViewController.addAction(distanceOne)
        alertViewController.addAction(distanceThree)
        alertViewController.addAction(distanceFive)
        alertViewController.addAction(cancel)
        self.present(alertViewController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if sections[indexPath.row] is PageSectionViewModel<Banner> {
            return CGSize(width: Dimension.SCREEN_WIDTH, height: Dimension.HEADER_HEIGHT)
        } else {
            return CGSize(width: Dimension.SCREEN_WIDTH, height: Dimension.AREA_HEIGHT)
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

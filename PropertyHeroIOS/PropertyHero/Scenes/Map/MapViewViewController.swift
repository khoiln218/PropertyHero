//
//  MapViewViewController.swift
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
import GoogleMaps
import GoogleMapsUtils

final class MapViewViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var findBtn: UIView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var myLocation: UIView!
    @IBOutlet weak var numItems: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var viewModel: MapViewViewModel!
    var disposeBag = DisposeBag()
    
    private var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    private let geocoder = GMSGeocoder()
    private let manager = CLLocationManager()
    private var oldMarker: GMSMarker?
    private var products: [Product]!
    private var clusters = [Product]()
    
    var cameraChanged = PublishSubject<GMSCoordinateBounds>()
    var viewmore = PublishSubject<Void>()
    var filter = PublishSubject<Void>()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeBackButtonTitle()
        
        let filterBtn = UIButton(type: .custom)
        filterBtn.setImage(UIImage(named: "vector_action_filter")!, for: .normal)
        filterBtn.addTarget(self, action: #selector(self.filterClick(_:)), for: UIControl.Event.touchUpInside)
        let filterCurrWidth = filterBtn.widthAnchor.constraint(equalToConstant: 24)
        filterCurrWidth.isActive = true
        let filterCurrHeight = filterBtn.heightAnchor.constraint(equalToConstant: 24)
        filterCurrHeight.isActive = true
        
        let rightBarButton = UIBarButtonItem(customView: filterBtn)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    deinit {
        logDeinit()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.rotateChange()
        }
    }
    
    // MARK: - Methods
    
    private func configView() {
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: ProductClusterCell.self)
        }
        collectionView.backgroundView = nil;
        collectionView.backgroundColor = .clear;
        
        findBtn.layer.borderWidth = 1
        findBtn.layer.borderColor = UIColor(hex: "#CFD8DC")?.cgColor
        findBtn.layer.cornerRadius = 3
        findBtn.layer.masksToBounds = true
        
        myLocation.layer.borderWidth = 1
        myLocation.layer.borderColor = UIColor(hex: "#CFD8DC")?.cgColor
        myLocation.layer.cornerRadius = 3
        myLocation.layer.masksToBounds = true
        
        viewAllBtn.layer.cornerRadius = 3
        viewAllBtn.layer.masksToBounds = true
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        myLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myLocationButton(_:))))
        findBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(findByMarkerButton(_:))))
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            print("Swipe Right")
        }
        else if gesture.direction == .left {
            print("Swipe Left")
        }
        else if gesture.direction == .up {
            print("Swipe Up")
        }
        else if gesture.direction == .down {
            print("Swipe Down")
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
                self.collectionView.transform = CGAffineTransform(translationX: 0, y: 150)
            }) { [unowned self] _ in
                self.collectionView.isHidden = true
                self.collectionView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            if let oldMarker = oldMarker {
                oldMarker.opacity = 1
            }
            oldMarker = nil
        }
    }
    
    @IBAction func viewAllDragOutside(_ sender: Any) {
        viewAllBtn.backgroundColor = UIColor(hex: "#2B50F6")!
    }
    
    @IBAction func viewAllPressed(_ sender: Any) {
        viewAllBtn.backgroundColor = UIColor(hex: "#FFA000")!
    }
    
    @IBAction func viewAll(_ sender: Any) {
        viewAllBtn.backgroundColor = UIColor(hex: "#2B50F6")!
        self.viewmore.onNext(())
    }
    
    @objc func filterClick(_ sender: Any) {
        self.filter.onNext(())
    }
    
    @objc func myLocationButton(_ sender: UITapGestureRecognizer) {
        manager.startUpdatingLocation()
    }
    
    @objc func findByMarkerButton(_ sender: UITapGestureRecognizer) {
        self.viewModel.navigator.toSearchByMarker()
    }
    
    func bindViewModel() {
        let input = MapViewViewModel.Input(
            filter: filter.asDriverOnErrorJustComplete(),
            cameraChaged: cameraChanged.asDriverOnErrorJustComplete(),
            viewmore: viewmore.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$title
            .asDriver()
            .drive(onNext: { [unowned self] title in
                if let title = title {
                    self.title = title
                }
            })
            .disposed(by: disposeBag)
        
        output.$latlng
            .asDriver()
            .drive(onNext: { [unowned self] latlng in
                if let latlng = latlng {
                    self.setupMap(latlng)
                }
            })
            .disposed(by: disposeBag)
        
        output.$products
            .asDriver()
            .drive(onNext: { [weak self] products in
                self?.products = products
                self?.numItems.text = "\(products.count)\("unit_item".localized())";
                self?.createClusterItems(products)
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
    }
    
    func rotateChange() {
        self.mapView.frame.size.width = Dimension.SCREEN_WIDTH
        self.mapView.frame.size.height = Dimension.SCREEN_HEIGHT
    }
    
    private func setupMap(_ latlng: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: latlng.latitude, longitude: latlng.longitude, zoom: DefaultStorage().getMapZoom())
        
        self.mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.container.insertSubview(mapView, at: 0)
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        
        clusterManager.setMapDelegate(self)
    }
    
    private func createClusterItems(_ products: [Product]) {
        self.clusterManager.clearItems()
        for product in products {
            let position = CLLocationCoordinate2D(latitude: product.Latitude, longitude: product.Longitude)
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "ic_vector_product_item")
            marker.userData = product
            clusterManager.add(marker)
        }
        self.clusterManager.cluster()
    }
}

// MARK: - UICollectionViewDataSource
extension MapViewViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clusters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(
            for: indexPath,
            cellType: ProductClusterCell.self
        )
        .then {
            $0.addBorders(edges: [.bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
            $0.bindViewModel(clusters[indexPath.row])
        }
    }
}

extension MapViewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.navigator.toProductDetail(self.clusters[indexPath.row].Id)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MapViewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 150.0 + 16.0
        let height = 150.0
        return CGSize(width: width, height: height)
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

// MARK: - GMSMapViewDelegate
extension MapViewViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        mapView.clear()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        if mapView.camera.zoom <= 7 { return }
        
        let camView = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: camView)
        DefaultStorage().setLastLatLng(cameraPosition.target.latitude, lng: cameraPosition.target.longitude, zoom: cameraPosition.zoom)
        self.cameraChanged.onNext(bounds)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let oldMarker = oldMarker {
            oldMarker.opacity = 1
        }
        clusters.removeAll()
        if marker.userData is GMUCluster {
            oldMarker = marker
            marker.opacity = 0.5
            guard let cluster = marker.userData as? GMUCluster else { return false }
            for item in cluster.items {
                let products = self.products.filter({ $0.Latitude == item.position.latitude && $0.Longitude == item.position.longitude })
                for product in products {
                    if !clusters.contains(where: {$0.Id == product.Id}) {
                        clusters.append(product)
                    }
                }
            }
            collectionView.isHidden = clusters.isEmpty
            collectionView.reloadData()
            collectionView.setContentOffset(.zero, animated: false)
            return true
        }
        oldMarker = nil
        collectionView.reloadData()
        collectionView.isHidden = true
        
        self.viewModel.navigator.toProductDetail((marker.userData as! Product).Id)
        return false
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.manager.stopUpdatingLocation()
        
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, zoom: DefaultStorage().getMapZoom())
        self.mapView.animate(to: camera)
    }
}

// MARK: - StoryboardSceneBased
extension MapViewViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.map
}

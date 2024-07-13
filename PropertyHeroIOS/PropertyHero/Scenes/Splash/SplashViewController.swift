//
//  MainViewController.swift
//  BaoDongThap
//
//  Created by KHOI LE on 9/20/22.
//

import UIKit
import Reusable
import SDWebImage
import RxSwift
import RxCocoa
import MGArchitecture
import CoreLocation

final class SplashViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    
    // MARK: - Properties
    
    var viewModel: SplashViewModel!
    var disposeBag = DisposeBag()
    
    private let manager = CLLocationManager()
    
    private let load = PublishSubject<CLLocationCoordinate2D>()
    private let lastLatlng = CLLocationCoordinate2D(latitude: DefaultStorage().getLastLat(), longitude: DefaultStorage().getLastLng())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func bindViewModel() {
        let input = SplashViewModel.Input(
            load: load.asDriverOnErrorJustComplete()
        )
        _ = viewModel.transform(input, disposeBag: disposeBag)
        
        DispatchQueue.global().async { [unowned self] in
            if CLLocationManager.locationServicesEnabled() {
                switch self.manager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    self.load.onNext(lastLatlng)
                case .authorizedAlways, .authorizedWhenInUse:
                    self.manager.startUpdatingLocation()
                @unknown default:
                    self.load.onNext(lastLatlng)
                    break
                }
            } else {
                self.load.onNext(lastLatlng)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension SplashViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.manager.stopUpdatingLocation()
        
        let location = locations.last
        guard let latlng = location?.coordinate else { self.load.onNext(lastLatlng); return }
        self.load.onNext(latlng)
    }
}

// MARK: - StoryboardSceneBased
extension SplashViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.splash
}

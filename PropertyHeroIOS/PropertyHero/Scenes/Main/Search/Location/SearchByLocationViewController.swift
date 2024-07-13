//
//  SearchByLocationViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/11/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import CoreLocation

final class SearchByLocationViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var provinceSpinner: UILabel!
    @IBOutlet weak var provinceIcon: UIImageView!
    @IBOutlet weak var districtSpinner: UILabel!
    @IBOutlet weak var districtIcon: UIImageView!
    @IBOutlet weak var searchBtn: UIButton!
    
    // MARK: - Properties
    
    var viewModel: SearchByLocationViewModel!
    var disposeBag = DisposeBag()
    
    private var provinces = [Province]()
    private var districts = [District]()
    private var provinceSubject = PublishSubject<Province>()
    private var districtSubject = PublishSubject<District>()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(provinceChanged(_:)),
                                               name: NSNotification.Name.settingChanged,
                                               object: nil)
        
        provinceSpinner.layer.borderWidth = 1
        provinceSpinner.layer.borderColor = UIColor(hex: "#CFD8DC")?.cgColor
        provinceSpinner.layer.cornerRadius = 3
        provinceSpinner.layer.masksToBounds = true
        provinceIcon.layer.cornerRadius = 3
        provinceIcon.layer.masksToBounds = true
        
        districtSpinner.layer.borderWidth = 1
        districtSpinner.layer.borderColor = UIColor(hex: "#CFD8DC")?.cgColor
        districtSpinner.layer.cornerRadius = 3
        districtSpinner.layer.masksToBounds = true
        districtIcon.layer.cornerRadius = 3
        districtIcon.layer.masksToBounds = true
        
        searchBtn.layer.cornerRadius = 3
        searchBtn.layer.masksToBounds = true
        
        provinceSpinner.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProviceChanged(_:))))
        districtSpinner.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDistrictChanged(_:))))
    }
    
    @IBAction func searchDragOutside(_ sender: Any) {
        searchBtn.backgroundColor = UIColor(hex: "#2B50F6")!
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchBtn.backgroundColor = UIColor(hex: "#FFA000")!
    }
    
    @objc func onProviceChanged(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "   ", message: "   ", preferredStyle: .actionSheet)
        
        let messageAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black]
         let messageString = NSAttributedString(string: "Chọn Tỉnh/Thành phố", attributes: messageAttributes)
        alert.setValue(messageString, forKey: "attributedMessage")
        
        for province in self.provinces {
            alert.addAction(UIAlertAction(title: province.Name, style: .default , handler:{ [unowned self] _ in
                self.provinceSubject.onNext(province)
                self.provinceSpinner.text = province.Name
            }))
        }
        alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onDistrictChanged(_ sender: UITapGestureRecognizer) {
            let alert = UIAlertController(title: "   ", message: "   ", preferredStyle: .actionSheet)
            
            let messageAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black]
             let messageString = NSAttributedString(string: "Chọn Quận/Huyện", attributes: messageAttributes)
            alert.setValue(messageString, forKey: "attributedMessage")
            
            for district in self.districts {
                alert.addAction(UIAlertAction(title: district.Name, style: .default , handler:{ [unowned self] _ in
                    self.districtSubject.onNext(district)
                    self.districtSpinner.text = district.Name
                }))
            }
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
    }
    
    func searchEnable() {
        searchBtn.isEnabled = true
        searchBtn.backgroundColor = UIColor(hex: "#2B50F6")!
    }
    
    @IBAction func search(_ sender: Any) {
        searchBtn.backgroundColor = UIColor(hex: "#2B50F6")!
    }
    
    func bindViewModel() {
        let input = SearchByLocationViewModel.Input(
                trigger: Driver.just(()),
                province: provinceSubject.asDriverOnErrorJustComplete(),
                district: districtSubject.asDriverOnErrorJustComplete(),
                search: searchBtn.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$proinces
            .asDriver()
            .drive(onNext: { [unowned self] provinces in
                if let provinces = provinces {
                    if let province = provinces.first(where: { $0.Id == DefaultStorage().getDefaultProvince() }) ?? provinces.first {
                        self.provinceSubject.onNext(province)
                        self.provinceSpinner.text = province.Name
                        self.provinces = provinces
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.$districts
            .asDriver()
            .drive(onNext: { [unowned self] districts in
                if let districts = districts {
                    if let district = districts.first {
                        self.districtSubject.onNext(district)
                        self.districtSpinner.text = district.Name
                        self.districts = districts
                        self.searchEnable()
                        return
                    }
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
    }
    
    @objc func provinceChanged(_ notification: Notification) {
        if let province = self.provinces.first(where: { $0.Id == DefaultStorage().getDefaultProvince() }) ?? self.provinces.first {
            self.provinceSubject.onNext(province)
            self.provinceSpinner.text = province.Name
        }
    }
}

// MARK: - StoryboardSceneBased
extension SearchByLocationViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

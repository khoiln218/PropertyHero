//
//  SettingViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/2/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then

final class SettingViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var provinceView: UIView!
    @IBOutlet weak var province: UILabel!
    @IBOutlet weak var provineSpin: UIStackView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var vesionLabel: UILabel!
    @IBOutlet weak var copyright: UILabel!
    
    // MARK: - Properties
    
    var viewModel: SettingViewModel!
    var disposeBag = DisposeBag()
    
    private var provinces = [Province]()
    private var provinceSubject = PublishSubject<Province>()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeBackButtonTitle()
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        title = "Cài đặt"
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        vesionLabel.text = "Phiên bản: \(appVersion ?? "1.0.0")"
        copyright.text = "©\(Calendar.current.component(.year, from: Date())) Một sản phẩm của Gomi Corporation"
        
        self.countryView.addBorders(edges: [.top], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.provinceView.addBorders(edges: [.top, .bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.languageView.addBorders(edges: [.bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.infoView.addBorders(edges: [.top, .bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        
        self.provineSpin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProviceChanged(_:))))
        self.infoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAbout(_:))))
    }
    
    @objc func onAbout(_ sender: UITapGestureRecognizer) {
        self.viewModel.navigator.toAbout()
    }
    
    @objc func onProviceChanged(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "   ", message: "   ", preferredStyle: .actionSheet)
        
        let messageAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black]
         let messageString = NSAttributedString(string: "Chọn Tỉnh/Thành phố", attributes: messageAttributes)
        alert.setValue(messageString, forKey: "attributedMessage")
        
        for province in self.provinces {
            alert.addAction(UIAlertAction(title: province.Name, style: .default , handler:{ [unowned self] _ in
                DefaultStorage().setDefaultProvince(province.Id)
                NotificationCenter.default.post(
                    name: Notification.Name.settingChanged,
                    object: nil)
                self.provinceSubject.onNext(province)
                self.province.text = province.Name
            }))
        }
        alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func bindViewModel() {
        let input = SettingViewModel.Input(
            trigger: Driver.just(()),
            province: provinceSubject.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$proinces
            .asDriver()
            .drive(onNext: { [unowned self] provinces in
                if let provinces = provinces {
                    if let province = provinces.first(where: { $0.Id == DefaultStorage().getDefaultProvince() }) ?? provinces.first {
                        self.provinceSubject.onNext(province)
                        self.province.text = province.Name
                        self.provinces = provinces
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
}

// MARK: - Binders
extension SettingViewController {
    
}

// MARK: - StoryboardSceneBased
extension SettingViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

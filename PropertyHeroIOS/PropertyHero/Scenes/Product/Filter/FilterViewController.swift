//
//  FilterViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/25/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import Dto

final class FilterViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var propertyView: UIView!
    @IBOutlet weak var propertyName: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var minPrice: UITextField!
    @IBOutlet weak var maxPrice: UITextField!
    @IBOutlet weak var areaView: UIView!
    @IBOutlet weak var minArea: UITextField!
    @IBOutlet weak var maxArea: UITextField!
    @IBOutlet weak var areaUnit: UILabel!
    @IBOutlet weak var bedView: UIView!
    @IBOutlet weak var bedAny: UIButton!
    @IBOutlet weak var bed1: UIButton!
    @IBOutlet weak var bed2: UIButton!
    @IBOutlet weak var bed3: UIButton!
    @IBOutlet weak var bed4: UIButton!
    @IBOutlet weak var bed5: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var areaError: UILabel!
    @IBOutlet weak var priceHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var viewModel: FilterViewModel!
    var disposeBag = DisposeBag()
    var properties = [PropertyId]()
    
    let resetBtn = PublishSubject<Void>()
    let propertySubject = PublishSubject<PropertyId>()
    let bedSubject = PublishSubject<Int>()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeBackButtonTitle()
        
        let resetBtn = UIButton(type: .custom)
        resetBtn.setImage(UIImage(named: "vector_action_reload")!, for: .normal)
        resetBtn.addTarget(self, action: #selector(self.resetClick(_:)), for: UIControl.Event.touchUpInside)
        let resetCurrWidth = resetBtn.widthAnchor.constraint(equalToConstant: 24)
        resetCurrWidth.isActive = true
        let resetCurrHeight = resetBtn.heightAnchor.constraint(equalToConstant: 24)
        resetCurrHeight.isActive = true
        
        let rightBarButton = UIBarButtonItem(customView: resetBtn)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.areaUnit.text = "m\u{00B2}"
        self.propertyView.addBorders(edges: [.top, .bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.priceView.addBorders(edges: [.top, .bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.areaView.addBorders(edges: [.top, .bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.bedView.addBorders(edges: [.top, .bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        
        self.bed1.addBorders(edges: [.top, .bottom, .right], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.bed2.addBorders(edges: [.top, .bottom, .right], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.bed3.addBorders(edges: [.top, .bottom, .right], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.bed4.addBorders(edges: [.top, .bottom, .right], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.bed5.addBorders(edges: [.top, .bottom, .right], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.bedAny.addBorders(edges: [.all], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.bedAnyClicked(UIButton())
    }
    
    @objc func resetClick(_ sender: Any) {
        resetBtn.onNext(())
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        title = "Bộ lọc nâng cao"
        updateBtn.layer.cornerRadius = 3
        updateBtn.layer.masksToBounds = true
        
        self.propertyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProperty(_:))))
    }
    
    @IBAction func bedAnyClicked(_ sender: Any) {
        resetBed()
        bedAny.backgroundColor = UIColor(hex: "#1b20f2")
        bedAny.setTitleColor(.white, for: .normal)
        bedSubject.onNext(0)
    }
    
    @IBAction func bed5Clicked(_ sender: Any) {
        resetBed()
        bed5.backgroundColor = UIColor(hex: "#1b20f2")
        bed5.setTitleColor(.white, for: .normal)
        bedSubject.onNext(5)
    }
    
    @IBAction func bed4Clicked(_ sender: Any) {
        resetBed()
        bed4.backgroundColor = UIColor(hex: "#1b20f2")
        bed4.setTitleColor(.white, for: .normal)
        bedSubject.onNext(4)
    }
    
    @IBAction func bed3Clicked(_ sender: Any) {
        resetBed()
        bed3.backgroundColor = UIColor(hex: "#1b20f2")
        bed3.setTitleColor(.white, for: .normal)
        bedSubject.onNext(3)
    }
    
    @IBAction func bed2Clicked(_ sender: Any) {
        resetBed()
        bed2.backgroundColor = UIColor(hex: "#1b20f2")
        bed2.setTitleColor(.white, for: .normal)
        bedSubject.onNext(2)
    }
    
    @IBAction func bed1Clicked(_ sender: Any) {
        resetBed()
        bed1.backgroundColor = UIColor(hex: "#1b20f2")
        bed1.setTitleColor(.white, for: .normal)
        bedSubject.onNext(1)
    }
    
    @objc func onProperty(_ sender: Any) {
        let alert = UIAlertController(title: "   ", message: "   ", preferredStyle: .actionSheet)
        
        let messageAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black]
         let messageString = NSAttributedString(string: "Loại bất động sản", attributes: messageAttributes)
        alert.setValue(messageString, forKey: "attributedMessage")
        
        for propertyId in self.properties {
            alert.addAction(UIAlertAction(title: propertyId.value, style: .default , handler:{ [unowned self] _ in
                self.propertySubject.onNext(propertyId)
                self.propertyName.text = propertyId.value
            }))
        }
        alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func bindViewModel() {
        let input = FilterViewModel.Input(
            load: Driver.just(()),
            update: updateBtn.rx.tap.asDriver(),
            reset: resetBtn.asDriverOnErrorJustComplete(),
            property: propertySubject.asDriverOnErrorJustComplete(),
            minPrice: minPrice.rx.text.orEmpty.asDriver(),
            maxPrice: maxPrice.rx.text.orEmpty.asDriver(),
            minArea: minArea.rx.text.orEmpty.asDriver(),
            maxArea: maxArea.rx.text.orEmpty.asDriver(),
            bed: bedSubject.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$filterSet
            .asDriver()
            .drive(onNext: { [unowned self] filterSet in
                if let filterSet = filterSet {
                    if let propertyId = self.properties.first(where: { Int($0.id) == filterSet.propertyID }) {
                        self.propertySubject.onNext(propertyId)
                        self.propertyName.text = propertyId.value
                    } else {
                        let first = self.properties.first
                        self.propertySubject.onNext(first!)
                        self.propertyName.text = first!.value
                    }
                    
                    if filterSet.bed == 1 {
                        self.bed1Clicked(UIButton())
                    } else if filterSet.bed == 2 {
                        self.bed2Clicked(UIButton())
                    } else if filterSet.bed == 3 {
                        self.bed3Clicked(UIButton())
                    } else if filterSet.bed == 4 {
                        self.bed4Clicked(UIButton())
                    } else if filterSet.bed == 5 {
                        self.bed5Clicked(UIButton())
                    } else {
                        self.bedAnyClicked(UIButton())
                    }
                    
                    self.minPrice.text = filterSet.minPrice > 0 ? String(filterSet.minPrice.clean) : nil
                    self.maxPrice.text = filterSet.maxPrice > 0 ? String(filterSet.maxPrice.clean) : nil
                    self.minArea.text = filterSet.minArea > 0 ? String(filterSet.minArea.clean) : nil
                    self.maxArea.text = filterSet.maxArea > 0 ? String(filterSet.maxArea.clean) : nil
                }
            })
            .disposed(by: disposeBag)
        
        output.$properties
            .asDriver()
            .drive(onNext: { [unowned self] properties in
                if let properties = properties {
                    self.properties = properties
                }
            })
            .disposed(by: disposeBag)
        
        output.$priceValidation
            .asDriver()
            .drive(priceValidationBinder)
            .disposed(by: disposeBag)
        
        output.$areaValidation
            .asDriver()
            .drive(areaValidationBinder)
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
    
    func resetBed() {
        bed1.backgroundColor = .white
        bed1.setTitleColor(UIColor(hex: "#424242"), for: .normal)
        bed2.backgroundColor = .white
        bed2.setTitleColor(UIColor(hex: "#424242"), for: .normal)
        bed3.backgroundColor = .white
        bed3.setTitleColor(UIColor(hex: "#424242"), for: .normal)
        bed4.backgroundColor = .white
        bed4.setTitleColor(UIColor(hex: "#424242"), for: .normal)
        bed5.backgroundColor = .white
        bed5.setTitleColor(UIColor(hex: "#424242"), for: .normal)
        bedAny.backgroundColor = .white
        bedAny.setTitleColor(UIColor(hex: "#424242"), for: .normal)
    }
}

// MARK: - Binders
extension FilterViewController {
    var priceValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.minPrice.backgroundColor = viewModel.backgroundColor
            vc.maxPrice.backgroundColor = viewModel.backgroundColor
            vc.priceHeight.constant = viewModel.text.isEmpty ? 48: 64
            vc.errorLabel.text = viewModel.text
            vc.errorLabel.isEnabled = !viewModel.text.isEmpty
        }
    }
    
    var areaValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.minArea.backgroundColor = viewModel.backgroundColor
            vc.maxArea.backgroundColor = viewModel.backgroundColor
            vc.areaError.text = viewModel.text
        }
    }
}

// MARK: - StoryboardSceneBased
extension FilterViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}

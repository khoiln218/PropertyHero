//
//  AccountInfoViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/31/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import DatePickerDialog
import Dto

final class AccountInfoViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var fullnameError: UILabel!
    @IBOutlet weak var fullnameHeight: NSLayoutConstraint!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var genderIcon: UIImageView!
    @IBOutlet weak var birthdayView: UIView!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var birthdayIcon: UIImageView!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var phoneNumberError: UILabel!
    @IBOutlet weak var phoneNumberHeight: NSLayoutConstraint!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var provinceView: UIView!
    @IBOutlet weak var province: UILabel!
    @IBOutlet weak var provinceIcon: UIImageView!
    @IBOutlet weak var districtView: UIView!
    @IBOutlet weak var district: UILabel!
    @IBOutlet weak var districtIcon: UIImageView!
    @IBOutlet weak var updateBtn: UIButton!
    
    // MARK: - Properties
    
    var viewModel: AccountInfoViewModel!
    var disposeBag = DisposeBag()
    
    let genderArr = [Gender.female.rawValue: GenderName.female.rawValue, Gender.male.rawValue: GenderName.male.rawValue, Gender.other.rawValue: GenderName.other.rawValue]
    
    private var account: Account!
    private var birthdaySelected: Date!
    private var provinces = [Province]()
    private var districts = [District]()
    private var genderSubject = PublishSubject<Int>()
    private var birthdaySubject = PublishSubject<Date>()
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
        title = "Thông tin cá nhân"
        
        genderView.layer.borderWidth = 0.5
        genderView.layer.borderColor = UIColor(hex: "#CFD8DC")?.cgColor
        genderView.layer.cornerRadius = 4
        genderView.layer.masksToBounds = true
        genderIcon.layer.cornerRadius = 3
        genderIcon.layer.masksToBounds = true
        
        birthdayView.layer.borderWidth = 0.5
        birthdayView.layer.borderColor = UIColor(hex: "#CFD8DC")?.cgColor
        birthdayView.layer.cornerRadius = 4
        birthdayView.layer.masksToBounds = true
        birthdayIcon.layer.cornerRadius = 3
        birthdayIcon.layer.masksToBounds = true
        
        provinceView.layer.borderWidth = 0.5
        provinceView.layer.borderColor = UIColor(hex: "#CFD8DC")?.cgColor
        provinceView.layer.cornerRadius = 4
        provinceView.layer.masksToBounds = true
        provinceIcon.layer.cornerRadius = 3
        provinceIcon.layer.masksToBounds = true
        
        districtView.layer.borderWidth = 0.5
        districtView.layer.borderColor = UIColor(hex: "#CFD8DC")?.cgColor
        districtView.layer.cornerRadius = 4
        district.layer.masksToBounds = true
        districtIcon.layer.cornerRadius = 3
        districtIcon.layer.masksToBounds = true
        
        updateBtn.layer.cornerRadius = 3
        updateBtn.layer.masksToBounds = true
        
        genderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGenderPicker(_:))))
        birthdayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBirthdayPicker(_:))))
        provinceView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProviceChanged(_:))))
        districtView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDistrictChanged(_:))))
    }
    
    @objc func onGenderPicker(_ sender: Any) {
        let alert = UIAlertController(title: "   ", message: "   ", preferredStyle: .actionSheet)
        
        let messageAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black]
         let messageString = NSAttributedString(string: "Giới tính", attributes: messageAttributes)
        alert.setValue(messageString, forKey: "attributedMessage")
        
        for key in self.genderArr.keys.sorted() {
            alert.addAction(UIAlertAction(title: self.genderArr[key], style: .default , handler:{ [unowned self] _ in
                self.genderSubject.onNext(key)
            }))
        }
        alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onBirthdayPicker(_ sender: Any) {
        DatePickerDialog(locale: Locale(identifier: "vi_VN")).show("Ngày sinh", doneButtonTitle: "Chọn", cancelButtonTitle: "Đóng", defaultDate: self.birthdaySelected, datePickerMode: .date) { [unowned self] date in
            if let dt = date {
                self.birthdaySelected = dt
                self.birthdaySubject.onNext(self.birthdaySelected)
            }
        }
    }
    
    @objc func onProviceChanged(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "   ", message: "   ", preferredStyle: .actionSheet)
        
        let messageAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black]
         let messageString = NSAttributedString(string: "Chọn Tỉnh/Thành phố", attributes: messageAttributes)
        alert.setValue(messageString, forKey: "attributedMessage")
        
        for province in self.provinces {
            alert.addAction(UIAlertAction(title: province.Name, style: .default , handler:{ [unowned self] _ in
                self.provinceSubject.onNext(province)
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
                }))
            }
            alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
    }
    
    func bindViewModel() {
        let input = AccountInfoViewModel.Input(
            trigger: Driver.just(()),
            gender: genderSubject.asDriverOnErrorJustComplete(),
            fullname: fullname.rx.text.orEmpty.asDriver(),
            phoneNumber: phoneNumber.rx.text.orEmpty.asDriver(),
            address: address.rx.text.orEmpty.asDriver(),
            birthday: birthdaySubject.asDriverOnErrorJustComplete(),
            province: provinceSubject.asDriverOnErrorJustComplete(),
            district: districtSubject.asDriverOnErrorJustComplete(),
            update: updateBtn.rx.tap.asDriver()
        )
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$isSuccessful
            .asDriver()
            .drive(onNext: { [unowned self] isSuccessful in
                if let isSuccessful = isSuccessful {
                    if isSuccessful {
                        self.onSuccess()
                    } else {
                        self.onFails()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.$data
            .asDriver()
            .drive(onNext: { [unowned self] data in
                if let account = data["account"] {
                    self.account = account as? Account
                    
                    self.fullname.text = self.account.FullName
                    self.phoneNumber.text = self.account.PhoneNumber
                    self.address.text = self.account.Address
                }
                
                if let provinces = data["provinces"] {
                    self.provinces = provinces as! [Province]
                }
                
                if let districts = data["districts"] {
                    self.districts = districts as! [District]
                }
            })
            .disposed(by: disposeBag)
        
        output.$birthday
            .asDriver()
            .drive(onNext: { [unowned self] birthday in
                if let birthday = birthday {
                    self.birthdaySelected = birthday
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    self.birthday.text = formatter.string(from: self.birthdaySelected)
                }
            })
            .disposed(by: disposeBag)
        
        output.$gender
            .asDriver()
            .drive(onNext: { [unowned self] gender in
                if let gender = gender {
                    self.gender.text = genderArr[gender]
                }
            })
            .disposed(by: disposeBag)
        
        output.$province
            .asDriver()
            .drive(onNext: { [unowned self] province in
                if let province = province {
                    self.province.text = province.Name
                }
            })
            .disposed(by: disposeBag)
        
        output.$district
            .asDriver()
            .drive(onNext: { [unowned self] district in
                if let district = district {
                    self.district.text = district.Name
                }
            })
            .disposed(by: disposeBag)
        
        output.$fullnameValidation
            .asDriver()
            .drive(fullnameValidationBinder)
            .disposed(by: disposeBag)
        
        output.$phoneNumberValidation
            .asDriver()
            .drive(phoneNumberValidationBinder)
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
    
    func onSuccess() {
        DispatchQueue.main.async { [unowned self] in
            NotificationCenter.default.post(
                name: Notification.Name.infoChanged,
                object: nil)
            self.dismissKeyboard()
            self.showAutoCloseMessage(image: nil, title: nil, message: "Cập nhật thành công")
        }
    }
    
    func onFails() {
        DispatchQueue.main.async {
            self.showAutoCloseMessage(image: nil, title: nil, message: "Lỗi hệ thống vui lòng thử lại")
        }
    }
}

// MARK: - Binders
extension AccountInfoViewController {
    var fullnameValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.fullname.backgroundColor = viewModel.backgroundColor
            vc.fullnameHeight.constant = viewModel.text.isEmpty ? 34: 52
            vc.fullnameError.text = viewModel.text
            vc.fullnameError.isHidden = viewModel.text.isEmpty
        }
    }
    
    var phoneNumberValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.phoneNumber.backgroundColor = viewModel.backgroundColor
            vc.phoneNumberHeight.constant = viewModel.text.isEmpty ? 34: 52
            vc.phoneNumberError.text = viewModel.text
            vc.phoneNumberError.isHidden = viewModel.text.isEmpty
        }
    }
}

// MARK: - StoryboardSceneBased
extension AccountInfoViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

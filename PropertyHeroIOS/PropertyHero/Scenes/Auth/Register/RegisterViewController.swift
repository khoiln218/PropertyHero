//
//  RegisterViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/21/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import Dto

final class RegisterViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var rePassword: UITextField!
    @IBOutlet weak var rePasswordError: UILabel!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var fullnameError: UILabel!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var phoneNumberError: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    
    // MARK: - Properties
    
    var viewModel: RegisterViewModel!
    var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeBackButtonTitle()
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        registerBtn.layer.cornerRadius = 3
        registerBtn.layer.masksToBounds = true
        
        title = "Đăng ký"
    }
    
    func bindViewModel() {
        let input = RegisterViewModel.Input(
            trigger: Driver.just(()),
            username: username.rx.text.orEmpty.asDriver(),
            password: password.rx.text.orEmpty.asDriver(),
            rePassword: rePassword.rx.text.orEmpty.asDriver(),
            fullname: fullname.rx.text.orEmpty.asDriver(),
            phoneNumber: phoneNumber.rx.text.orEmpty.asDriver(),
            register: registerBtn.rx.tap.asDriver())
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$accounts
            .asDriver()
            .drive(onNext: { [unowned self] accounts in
                if let accounts = accounts {
                    if !accounts.isEmpty {
                        let accountResult = accounts[0]
                        self.onSuccess(accountResult)
                    } else {
                        self.onFails()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.$usernameValidation
            .asDriver()
            .drive(usernameValidationBinder)
            .disposed(by: disposeBag)
        
        output.$passwordValidation
            .asDriver()
            .drive(passwordValidationBinder)
            .disposed(by: disposeBag)
        
        output.$rePasswordValidation
            .asDriver()
            .drive(rePasswordValidationBinder)
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
    
    func onSuccess(_ account: Account) {
        DispatchQueue.main.async { [unowned self] in
            AccountStorage().savePassword(self.password.text!)
            AccountStorage().saveAccount(account)
            AccountStorage().setIsLogin()
            NotificationCenter.default.post(
                name: Notification.Name.loginSuccess,
                object: nil,
                userInfo: ["account": account])
            self.showAutoCloseMessage(image: nil, title: nil, message: "Đăng ký thành công") {
                self.viewModel.navigator.goBack()
            }
        }
    }
    
    func onFails() {
        DispatchQueue.main.async {
            self.showAutoCloseMessage(image: nil, title: nil, message: "Lỗi hệ thống vui lòng thử lại")
        }
    }
}

// MARK: - Binders
extension RegisterViewController {
    var usernameValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.username.backgroundColor = viewModel.backgroundColor
            vc.usernameError.text = viewModel.text
        }
    }
    
    var passwordValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.password.backgroundColor = viewModel.backgroundColor
            vc.passwordError.text = viewModel.text
        }
    }
    
    var rePasswordValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.rePassword.backgroundColor = viewModel.backgroundColor
            vc.rePasswordError.text = viewModel.text
        }
    }
    
    var fullnameValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.fullname.backgroundColor = viewModel.backgroundColor
            vc.fullnameError.text = viewModel.text
        }
    }
    
    var phoneNumberValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.phoneNumber.backgroundColor = viewModel.backgroundColor
            vc.phoneNumberError.text = viewModel.text
        }
    }
}

// MARK: - StoryboardSceneBased
extension RegisterViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.auth
}

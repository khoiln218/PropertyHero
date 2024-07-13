//
//  LoginEmailViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/20/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import Dto

final class LoginEmailViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var usernameError: UILabel!
    @IBOutlet weak var passwordError: UILabel!
    
    // MARK: - Properties
    
    var viewModel: LoginEmailViewModel!
    var disposeBag = DisposeBag()
    
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
        loginBtn.layer.cornerRadius = 3
        loginBtn.layer.masksToBounds = true
        
        title = "Đăng nhập với Email"
        username.text = AccountStorage().getUsername()
    }
    
    func bindViewModel() {
        let input = LoginEmailViewModel.Input(
            trigger: Driver.just(()),
            username: username.rx.text.orEmpty.asDriver(),
            password: password.rx.text.orEmpty.asDriver(),
            login: loginBtn.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$usernameValidation
            .asDriver()
            .drive(usernameValidationBinder)
            .disposed(by: disposeBag)
        
        output.$passwordValidation
            .asDriver()
            .drive(passwordValidationBinder)
            .disposed(by: disposeBag)
        
        output.$accounts
            .asDriver()
            .drive(onNext: { [unowned self] accounts in
                if let accounts = accounts {
                    if !accounts.isEmpty {
                        let accountResult = accounts[0]
                        if accountResult.AccountType == AccountStatus.accLocked.rawValue {
                            self.onAccLock()
                        } else if accountResult.AccountType == AccountStatus.accDeletion.rawValue {
                            self.onDeletion()
                        } else {
                            self.onSuccess(accountResult)
                        }
                    } else {
                        self.onFails()
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
    
    func onSuccess(_ account: Account) {
        DispatchQueue.main.async { [unowned self] in
            let newAccount = Account(Id: account.Id, UserName: account.UserName, FullName: account.FullName, PhoneNumber: account.PhoneNumber, Avatar: account.Avatar, AccountRole: account.AccountRole, AccountType: AccountType.hero.rawValue)
            AccountStorage().savePassword(self.password.text!)
            AccountStorage().saveAccount(newAccount)
            AccountStorage().setIsLogin()
            NotificationCenter.default.post(
                name: Notification.Name.loginSuccess,
                object: nil,
                userInfo: ["account": account])
            self.showAutoCloseMessage(image: nil, title: nil, message: "Đăng nhập thành công") {
                self.viewModel.navigator.goBack()
            }
        }
    }
    
    func onAccLock() {
        DispatchQueue.main.async {
            self.showAutoCloseMessage(image: nil, title: nil, message: "Tài khoản đã bị khóa tạm thời")
        }
    }
    
    func onDeletion() {
        DispatchQueue.main.async {
            self.showAutoCloseMessage(image: nil, title: nil, message: "Tài khoản đã bị xóa")
        }
    }
    
    func onFails() {
        DispatchQueue.main.async {
            self.showAutoCloseMessage(image: nil, title: nil, message: "Tài khoản hoặc mật khẩu không đúng")
        }
    }
}

// MARK: - Binders
extension LoginEmailViewController {
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
}

// MARK: - StoryboardSceneBased
extension LoginEmailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.auth
}

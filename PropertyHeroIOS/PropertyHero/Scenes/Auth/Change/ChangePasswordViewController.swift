//
//  ChangePasswordViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/29/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import Dto

final class ChangePasswordViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var oldPasswordError: UILabel!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordError: UILabel!
    @IBOutlet weak var rePassword: UITextField!
    @IBOutlet weak var rePasswordError: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    
    // MARK: - Properties
    
    var viewModel: ChangePasswordViewModel!
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
        updateBtn.layer.cornerRadius = 3
        updateBtn.layer.masksToBounds = true
        
        title = "Đổi mật khẩu"
    }
    
    func bindViewModel() {
        let input = ChangePasswordViewModel.Input(
            oldPassword: oldPassword.rx.text.orEmpty.asDriver(),
            newPassword: newPassword.rx.text.orEmpty.asDriver(),
            rePassword: rePassword.rx.text.orEmpty.asDriver(),
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
        
        output.$oldPassswordValidation
            .asDriver()
            .drive(oldPasswordValidationBinder)
            .disposed(by: disposeBag)
        
        output.$passwordValidation
            .asDriver()
            .drive(passwordValidationBinder)
            .disposed(by: disposeBag)
        
        output.$rePasswordValidation
            .asDriver()
            .drive(rePasswordValidationBinder)
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
        DispatchQueue.main.async {
            self.showAutoCloseMessage(image: nil, title: nil, message: "Cập nhật thành công") {
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
extension ChangePasswordViewController {
    var oldPasswordValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.oldPassword.backgroundColor = viewModel.backgroundColor
            vc.oldPasswordError.text = viewModel.text
        }
    }
    
    var passwordValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.newPassword.backgroundColor = viewModel.backgroundColor
            vc.newPasswordError.text = viewModel.text
        }
    }
    
    var rePasswordValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.rePassword.backgroundColor = viewModel.backgroundColor
            vc.rePasswordError.text = viewModel.text
        }
    }
}

// MARK: - StoryboardSceneBased
extension ChangePasswordViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.auth
}

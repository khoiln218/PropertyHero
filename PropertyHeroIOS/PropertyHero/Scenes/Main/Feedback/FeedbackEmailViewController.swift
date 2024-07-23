//
//  FeedbackEmailViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/28/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import Dto
import MessageUI

final class FeedbackEmailViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var fullnameError: UILabel!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var phoneNumberError: UILabel!
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var contentError: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    
    // MARK: - Properties
    
    var viewModel: FeedbackEmailViewModel!
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
        title = "Email góp ý"
        
        sendBtn.layer.cornerRadius = 3
        sendBtn.layer.masksToBounds = true
        
        let account = AccountStorage().getAccount()
        fullname.text = account.FullName
        phoneNumber.text = account.PhoneNumber
    }
    
    func bindViewModel() {
        let input = FeedbackEmailViewModel.Input(
            fullname: fullname.rx.text.orEmpty.asDriver(),
            phoneNumber: phoneNumber.rx.text.orEmpty.asDriver(),
            content: content.rx.text.orEmpty.asDriver(),
            send: sendBtn.rx.tap.asDriver())
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$isSuccessful
            .asDriver()
            .drive(onNext: { [unowned self] isSuccessful in
                if let isSuccessful = isSuccessful {
                    if isSuccessful {
                        self.sendEmail()
                    }
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
        
        output.$contentValidation
            .asDriver()
            .drive(contentValidationBinder)
            .disposed(by: disposeBag)
    }
    
    func sendEmail() {
        if sendByURL(to: ["info@gomicorp.vn"], subject: fullname.text! + " - " + phoneNumber.text!, body: content.text!, isHtml: true) {
            showAutoCloseMessage(image: nil, title: nil, message: "Rất cảm ơn bạn đã đóng góp ý kiến về Property Hero.") {
                self.viewModel.navigator.goBack()
            }
        } else {
            showAutoCloseMessage(image: nil, title: nil, message: "Xảy ra lỗi vui lòng thử lại")
        }
    }
    
    func sendByURL(to: [String], subject: String, body: String, isHtml: Bool) -> Bool {
        var txtBody = body
        if isHtml {
            txtBody = body.replacingOccurrences(of: "<br />", with: "\n")
            txtBody = txtBody.replacingOccurrences(of: "<br/>", with: "\n")
            if txtBody.contains("/>") {
                return false
            }
        }
        
        let toJoined = to.joined(separator: ",")
        guard var feedbackUrl = URLComponents.init(string: "mailto:\(toJoined)") else {
            return false
        }
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem.init(name: "SUBJECT", value: subject))
        queryItems.append(URLQueryItem.init(name: "BODY",
                                            value: txtBody))
        feedbackUrl.queryItems = queryItems
        
        if let url = feedbackUrl.url {
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url)
                return true
            }
        }
        
        return false
    }
}

// MARK: - Binders
extension FeedbackEmailViewController {
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
    
    var contentValidationBinder: Binder<ValidationResult> {
        return Binder(self) { vc, result in
            let viewModel = ValidationResultViewModel(validationResult: result)
            vc.content.backgroundColor = viewModel.backgroundColor
            vc.contentError.text = viewModel.text
        }
    }
}

// MARK: - StoryboardSceneBased
extension FeedbackEmailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

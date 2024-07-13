//
//  MoreViewController.swift
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

final class MoreViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var account: UIView!
    @IBOutlet weak var accountAvatar: UIImageView!
    @IBOutlet weak var accountInfo: UIStackView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var rating: UIView!
    @IBOutlet weak var feedback: UIView!
    @IBOutlet weak var myProduct: UIView!
    @IBOutlet weak var setting: UIView!
    
    // MARK: - Properties
    
    var viewModel: MoreViewModel!
    var disposeBag = DisposeBag()
    
    var load = PublishSubject<Void>()
    
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
                                               selector: #selector(loginSuccess(_:)),
                                               name: NSNotification.Name.loginSuccess,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setupLogoutUI(_:)),
                                               name: NSNotification.Name.logout,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateAvatar(_:)),
                                               name: NSNotification.Name.avatarChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(infoChange(_:)),
                                               name: NSNotification.Name.infoChanged,
                                               object: nil)
        
        self.account.addBorders(edges: [.bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.rating.addBorders(edges: [.top, .bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.feedback.addBorders(edges: [.bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.myProduct.addBorders(edges: [.top, .bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.setting.addBorders(edges: [.top,.bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        
        let isLogin = AccountStorage().isLogin()
        if isLogin {
            let account = AccountStorage().getAccount()
            loginLabel.hidden()
            accountInfo.visible()
            accountAvatar.setAvatarImage(with: URL(string: account.Avatar))
            fullname.text = account.FullName
        }
        
        self.account.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAccount(_:))))
        self.rating.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRating(_:))))
        self.feedback.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFeedback(_:))))
        self.myProduct.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMyProduct(_:))))
        self.setting.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSetting(_:))))
        
        self.accountAvatar.layer.borderWidth = 1.0
        self.accountAvatar.layer.masksToBounds = false
        self.accountAvatar.layer.borderColor = UIColor.white.cgColor
        self.accountAvatar.layer.cornerRadius = accountAvatar.frame.size.width / 2
        self.accountAvatar.clipsToBounds = true
    }
    
    @objc func onAccount(_ sender: UITapGestureRecognizer) {
        let isLogin = AccountStorage().isLogin()
        if isLogin {
            self.viewModel.navigator.toProfile(AccountStorage().getAccount())
        } else {
            self.viewModel.navigator.toLogin()
        }
    }
    
    @objc func onRating(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://apps.apple.com/app/id6461215254") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func onFeedback(_ sender: UITapGestureRecognizer) {
        let isLogin = AccountStorage().isLogin()
        if isLogin {
            self.viewModel.navigator.toFeedback()
        } else {
            self.viewModel.navigator.toLogin()
        }
    }
    
    @objc func onMyProduct(_ sender: UITapGestureRecognizer) {
        print(#function)
    }
    
    @objc func onSetting(_ sender: UITapGestureRecognizer) {
        self.viewModel.navigator.toSetting()
    }
    
    @objc func setupLogoutUI(_ notification: NSNotification) {
        accountAvatar.image = UIImage(named: "vector_action_login")
        loginLabel.visible()
        accountInfo.hidden()
    }
    
    @objc func updateAvatar(_ notification: NSNotification) {
        let account = AccountStorage().getAccount()
        accountAvatar.setAvatarImage(with: URL(string: account.Avatar))
    }
    
    func bindViewModel() {
        let input = MoreViewModel.Input(
            load: load.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$account
            .asDriver()
            .drive(onNext:  { [unowned self] account in
                if let account = account {
                    loginLabel.hidden()
                    accountInfo.visible()
                    accountAvatar.setAvatarImage(with: URL(string: account.Avatar))
                    fullname.text = account.FullName
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func loginSuccess(_ notification: NSNotification) {
        if notification.name == Notification.Name.loginSuccess {
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String: Account] else { return }
                let account = userInfo["account"]!
                loginLabel.hidden()
                accountInfo.visible()
                accountAvatar.setAvatarImage(with: URL(string: account.Avatar))
                fullname.text = account.FullName
            }
        }
    }
    
    @objc func infoChange(_ notification: NSNotification) {
        if notification.name == Notification.Name.infoChanged {
            load.onNext(())
        }
    }
}

// MARK: - Binders
extension MoreViewController {
    
}

// MARK: - StoryboardSceneBased
extension MoreViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

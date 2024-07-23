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
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var contactView: UIStackView!
    @IBOutlet weak var ratingView: UIStackView!
    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var twitterView: UIStackView!
    @IBOutlet weak var telegramView: UIStackView!
    
    // MARK: - Properties
    
    var viewModel: MoreViewModel!
    var disposeBag = DisposeBag()
    
    var load = PublishSubject<Void>()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        
        let isLogin = AccountStorage().isLogin()
        if isLogin {
            let account = AccountStorage().getAccount()
            loginLabel.hidden()
            accountInfo.visible()
            logOut.visible()
            accountAvatar.setAvatarImage(with: URL(string: account.Avatar))
            fullname.text = account.FullName
            username.text = account.UserName
        } else {
            logOut.hidden()
        }
        
        self.account.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAccount(_:))))
        self.infoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAbout(_:))))
        self.telegramView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTelegram(_:))))
        self.twitterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTwitter(_:))))
        self.ratingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onRating(_:))))
        self.contactView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFeedback(_:))))
        
        self.accountAvatar.layer.borderWidth = 1.0
        self.accountAvatar.layer.masksToBounds = false
        self.accountAvatar.layer.borderColor = UIColor.white.cgColor
        self.accountAvatar.layer.cornerRadius = accountAvatar.frame.size.width / 2
        self.accountAvatar.clipsToBounds = true
        
        logOut.layer.borderWidth = 1.0
        logOut.layer.borderColor = UIColor(hex: "#486BF6")?.cgColor
        logOut.layer.cornerRadius = 5.0
        logOut.clipsToBounds = true
    }
    
    @IBAction func onSignOut(_ sender: Any) {
        AccountStorage().logout()
        NotificationCenter.default.post(
            name: Notification.Name.logout,
            object: nil)
    }
    
    @objc func onAbout(_ sender: UITapGestureRecognizer) {
        self.viewModel.navigator.toAbout()
    }
    
    @objc func onTelegram(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://t.me/propertyheroes") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func onTwitter(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://x.com/PHR_Hero") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func onAccount(_ sender: UITapGestureRecognizer) {
        let isLogin = AccountStorage().isLogin()
        if isLogin {
            self.viewModel.navigator.toAccountInfo()
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
        logOut.hidden()
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
                    logOut.visible()
                    accountAvatar.setAvatarImage(with: URL(string: account.Avatar))
                    fullname.text = account.FullName
                    username.text = account.UserName
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
                logOut.visible()
                accountAvatar.setAvatarImage(with: URL(string: account.Avatar))
                fullname.text = account.FullName
                username.text = account.UserName
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

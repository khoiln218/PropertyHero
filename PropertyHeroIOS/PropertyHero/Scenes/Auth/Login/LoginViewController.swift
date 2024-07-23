//
//  LoginViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/4/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import GoogleSignIn
import FacebookCore
import FacebookLogin
import AuthenticationServices

final class LoginViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var appleLogin: UIButton!
    @IBOutlet weak var facebookLogin: UIButton!
    @IBOutlet weak var googleLogin: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    // MARK: - Properties
    
    var viewModel: LoginViewModel!
    var disposeBag = DisposeBag()
    
    let login = PublishSubject<Account>()
    
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
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] _ in
            if let token = AccessToken.current, !token.isExpired {
                let accessToken =  token.tokenString
                self?.getAccountFBInformation(accessToken: accessToken)
            }
        }
        
        loginBtn.layer.cornerRadius = 3
        loginBtn.layer.masksToBounds = true
        
        title = "Đăng nhập Property Hero"
    }
    
    @IBAction func loginApple(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @IBAction func loginGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error == nil && user != nil {
                GIDSignIn.sharedInstance.signOut()
            }
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] signInResult, error in
                guard error == nil else { return }
                guard let signInResult = signInResult else { return }
                getAccountGoogleInformation(signInResult.user)
            }
        }
    }
    
    @IBAction func loginFacebook(_ sender: Any) {
        if let _ = AccessToken.current {
            LoginManager().logOut()
        }
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self)
    }
     
    @IBAction func loginWithEmail(_ sender: Any) {
        self.viewModel.navigator.toLoginEmail()
    }
    
    @IBAction func registerMember(_ sender: Any) {
        self.viewModel.navigator.toRegister()
    }
    
    func bindViewModel() {
        let input = LoginViewModel.Input(
            login: login.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
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
    
    func getAccountGoogleInformation(_ user: GIDGoogleUser) {
        let userId = user.userID!
        let fullName = user.profile!.name
        let email = user.profile!.email
        loginSuccess(accType: .google, id: userId, fullName: fullName, email: email)
    }
    
    func getAccountFBInformation(accessToken: String) {
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: accessToken, version: nil, httpMethod: .get )
        req.start { [unowned self] (connection, result, error) -> Void in
            if error == nil {
                guard let userInfo = result as? NSDictionary else { return }
                let email = userInfo["email"] as? String ?? ""
                let fullName = userInfo["name"] as! String
                let userId = userInfo["id"] as! String
                self.loginSuccess(accType: .facebook, id: userId, fullName: fullName, email: email)
            }
            else {
                print("error \(error!)")
            }
        }
    }
    
    func loginSuccess(accType: AccountType, id: String, fullName: String, email: String) {
        let account = Account(UserName: id, FullName: fullName, Email: email, AccountType: accType.rawValue)
        print(account)
        login.onNext(account)
    }
    
    func onSuccess(_ account: Account) {
        DispatchQueue.main.async { [unowned self] in
            let newAccount = Account(Id: account.Id, UserName: account.UserName, FullName: account.FullName, PhoneNumber: account.PhoneNumber, Avatar: account.Avatar, AccountRole: account.AccountRole, AccountType: account.AccountType)
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

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email ?? ""
            
            if #available(iOS 15.0, *) {
                self.loginSuccess(accType: .apple, id: userId, fullName: fullName?.formatted(.name(style: .long)) ?? "Guest", email: email)
            } else {
                var name = fullName?.givenName ?? "Guest"
                if let familyName = fullName?.familyName {
                    name.append(" ")
                    name.append(familyName)
                }
                self.loginSuccess(accType: .apple, id: userId, fullName: name, email: email)
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// MARK: - StoryboardSceneBased
extension LoginViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.auth
}
